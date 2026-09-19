const PROJECT_ID = 'doctorsuplementos-4bbb1';
const MODEL = 'gemini-3.1-flash-lite';
const MAX_BODY_BYTES = 18 * 1024 * 1024;
const MAX_PROMPT_BYTES = 60000;
const MAX_ATTACHMENTS = 5;
const MAX_ATTACHMENT_BYTES = 8 * 1024 * 1024;
const MAX_TOTAL_ATTACHMENT_BYTES = 12 * 1024 * 1024;
const MAX_OUTPUT_TOKENS = 4096;
const AUTH_TIMEOUT_MS = 10000;
const UPSTREAM_TIMEOUT_MS = 55000;
const ALLOWED_MIME_TYPES = new Set([
  'image/jpeg',
  'image/png',
  'image/webp',
  'application/pdf',
  'audio/mp4',
]);
const ALLOWED_ORIGINS = new Set([
  'https://daavidpkr.github.io',
  'http://localhost:7357',
  'http://127.0.0.1:7357',
]);

function response(origin, status, code, message) {
  const headers = {
    'Content-Type': 'application/json; charset=utf-8',
    'Cache-Control': 'no-store',
    'X-Content-Type-Options': 'nosniff',
  };
  if (origin && ALLOWED_ORIGINS.has(origin)) {
    headers['Access-Control-Allow-Origin'] = origin;
    headers.Vary = 'Origin';
  }
  return new Response(JSON.stringify({error: {code, message}}), {
    status,
    headers,
  });
}

function success(origin, text) {
  const headers = {
    'Content-Type': 'application/json; charset=utf-8',
    'Cache-Control': 'no-store',
    'X-Content-Type-Options': 'nosniff',
  };
  if (origin && ALLOWED_ORIGINS.has(origin)) {
    headers['Access-Control-Allow-Origin'] = origin;
    headers.Vary = 'Origin';
  }
  return new Response(JSON.stringify({text}), {
    status: 200,
    headers,
  });
}

function decodeClaims(token) {
  const pieces = token.split('.');
  if (pieces.length !== 3) return null;
  try {
    const normalized = pieces[1].replace(/-/g, '+').replace(/_/g, '/');
    const padded = normalized.padEnd(Math.ceil(normalized.length / 4) * 4, '=');
    return JSON.parse(atob(padded));
  } catch (_) {
    return null;
  }
}

async function validateFirebaseToken(token, firebaseApiKey) {
  const claims = decodeClaims(token);
  const now = Math.floor(Date.now() / 1000);
  if (!claims ||
      claims.aud !== PROJECT_ID ||
      claims.iss !== `https://securetoken.google.com/${PROJECT_ID}` ||
      typeof claims.sub !== 'string' ||
      claims.sub.length === 0 ||
      claims.sub.length > 128 ||
      typeof claims.exp !== 'number' ||
      claims.exp <= now ||
      typeof claims.iat !== 'number' ||
      claims.iat > now + 30 ||
      claims.firebase?.sign_in_provider !== 'anonymous') {
    return false;
  }

  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), AUTH_TIMEOUT_MS);
  let verification;
  try {
    verification = await fetch(
      'https://identitytoolkit.googleapis.com/v1/accounts:lookup',
      {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': firebaseApiKey,
        },
        body: JSON.stringify({idToken: token}),
        signal: controller.signal,
      },
    );
  } finally {
    clearTimeout(timeout);
  }
  if (!verification.ok) return false;
  const body = await verification.json();
  return Array.isArray(body.users) &&
      body.users.length === 1 &&
      body.users[0]?.localId === claims.sub;
}

function decodedBase64Bytes(data) {
  if (typeof data !== 'string' || data.length === 0 || data.length % 4 !== 0 ||
      !/^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$/.test(data)) {
    return -1;
  }
  const padding = data.endsWith('==') ? 2 : data.endsWith('=') ? 1 : 0;
  return (data.length / 4) * 3 - padding;
}

function attachmentSignatureMatches(mimeType, data) {
  let prefix;
  try {
    prefix = Uint8Array.from(atob(data.slice(0, 64)), (char) => char.charCodeAt(0));
  } catch (_) {
    return false;
  }
  const matchesAt = (offset, signature) =>
    prefix.length >= offset + signature.length &&
    signature.every((value, index) => prefix[offset + index] === value);
  switch (mimeType) {
    case 'image/jpeg':
      return matchesAt(0, [0xFF, 0xD8, 0xFF]);
    case 'image/png':
      return matchesAt(0, [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]);
    case 'image/webp':
      return matchesAt(0, [0x52, 0x49, 0x46, 0x46]) &&
        matchesAt(8, [0x57, 0x45, 0x42, 0x50]);
    case 'application/pdf':
      return matchesAt(0, [0x25, 0x50, 0x44, 0x46, 0x2D]);
    case 'audio/mp4':
      return matchesAt(4, [0x66, 0x74, 0x79, 0x70]);
    default:
      return false;
  }
}

function validateAttachments(value) {
  if (value === undefined) return {attachments: [], totalBytes: 0};
  if (!Array.isArray(value) || value.length === 0 || value.length > MAX_ATTACHMENTS) {
    return null;
  }
  let totalBytes = 0;
  for (const attachment of value) {
    if (!attachment || typeof attachment !== 'object' || Array.isArray(attachment) ||
        Object.keys(attachment).length !== 2 ||
        typeof attachment.mimeType !== 'string' ||
        !ALLOWED_MIME_TYPES.has(attachment.mimeType)) {
      return null;
    }
    const bytes = decodedBase64Bytes(attachment.data);
    if (bytes <= 0 || bytes > MAX_ATTACHMENT_BYTES) return null;
    if (!attachmentSignatureMatches(attachment.mimeType, attachment.data)) return null;
    totalBytes += bytes;
    if (totalBytes > MAX_TOTAL_ATTACHMENT_BYTES) return null;
  }
  return {attachments: value, totalBytes};
}

function extractText(body) {
  const parts = body?.candidates?.[0]?.content?.parts;
  if (!Array.isArray(parts)) return '';
  return parts
    .map((part) => typeof part?.text === 'string' ? part.text : '')
    .join('')
    .trim();
}

export default {
  async fetch(request, env) {
    const origin = request.headers.get('Origin') || '';
    if (origin && !ALLOWED_ORIGINS.has(origin)) {
      return response(null, 403, 'ORIGEN_NO_PERMITIDO', 'Origen no permitido.');
    }

    const url = new URL(request.url);
    if (url.pathname !== '/v1/generate') {
      return response(origin, 404, 'RUTA_NO_ENCONTRADA', 'Ruta no encontrada.');
    }
    if (request.method === 'OPTIONS') {
      const requestedMethod =
        request.headers.get('Access-Control-Request-Method');
      const requestedHeaders =
        (request.headers.get('Access-Control-Request-Headers') || '')
            .toLowerCase()
            .split(',')
            .map((value) => value.trim())
            .filter(Boolean);
      if (requestedMethod !== 'POST' ||
          requestedHeaders.some((header) =>
            header !== 'authorization' && header !== 'content-type')) {
        return response(origin, 403, 'PREFLIGHT_RECHAZADO', 'Solicitud no permitida.');
      }
      return new Response(null, {
        status: 204,
        headers: {
          'Access-Control-Allow-Origin': origin,
          'Access-Control-Allow-Methods': 'POST, OPTIONS',
          'Access-Control-Allow-Headers': 'Authorization, Content-Type',
          'Access-Control-Max-Age': '600',
          Vary: 'Origin',
        },
      });
    }
    if (request.method !== 'POST') {
      return response(origin, 405, 'METODO_NO_PERMITIDO', 'Método no permitido.');
    }
    const contentType = request.headers.get('Content-Type') || '';
    if (!/^application\/json(?:\s*;|$)/i.test(contentType)) {
      return response(origin, 415, 'TIPO_NO_ADMITIDO', 'Se requiere JSON.');
    }
    const declaredLength = Number(request.headers.get('Content-Length') || 0);
    if (declaredLength > MAX_BODY_BYTES) {
      return response(origin, 413, 'PAYLOAD_DEMASIADO_GRANDE', 'Solicitud demasiado grande.');
    }

    const authorization = request.headers.get('Authorization') || '';
    const match = /^Bearer ([A-Za-z0-9._-]+)$/.exec(authorization);
    if (!match || match[1].length > 4096) {
      return response(origin, 401, 'TOKEN_REQUERIDO', 'Autenticación requerida.');
    }
    if (!env.GEMINI_API_KEY || !env.FIREBASE_API_KEY) {
      return response(origin, 503, 'SERVICIO_NO_CONFIGURADO', 'Servicio no disponible.');
    }

    let tokenValid;
    try {
      tokenValid = await validateFirebaseToken(match[1], env.FIREBASE_API_KEY);
    } catch (_) {
      return response(origin, 503, 'VALIDACION_NO_DISPONIBLE', 'Validación no disponible.');
    }
    if (!tokenValid) {
      return response(origin, 401, 'TOKEN_INVALIDO', 'Token inválido o expirado.');
    }

    let rawBody;
    try {
      rawBody = await request.text();
    } catch (_) {
      return response(origin, 400, 'JSON_INVALIDO', 'JSON inválido.');
    }
    if (new TextEncoder().encode(rawBody).length > MAX_BODY_BYTES) {
      return response(origin, 413, 'PAYLOAD_DEMASIADO_GRANDE', 'Solicitud demasiado grande.');
    }

    let payload;
    try {
      payload = JSON.parse(rawBody);
    } catch (_) {
      return response(origin, 400, 'JSON_INVALIDO', 'JSON inválido.');
    }
    if (!payload ||
        typeof payload !== 'object' ||
        Array.isArray(payload) ||
        !Object.keys(payload).every((key) => key === 'prompt' || key === 'attachments') ||
        typeof payload.prompt !== 'string') {
      return response(origin, 400, 'PAYLOAD_INVALIDO', 'Solicitud inválida.');
    }
    const promptBytes = new TextEncoder().encode(payload.prompt).length;
    if (payload.prompt.trim().length === 0 || promptBytes > MAX_PROMPT_BYTES) {
      return response(origin, 400, 'PROMPT_INVALIDO', 'Texto inválido.');
    }
    const validatedAttachments = validateAttachments(payload.attachments);
    if (!validatedAttachments) {
      return response(origin, 400, 'ADJUNTOS_INVALIDOS', 'Archivos adjuntos inválidos.');
    }

    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), UPSTREAM_TIMEOUT_MS);
    let upstream;
    try {
      upstream = await fetch(
        `https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent`,
        {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-Goog-Api-Key': env.GEMINI_API_KEY,
          },
          body: JSON.stringify({
            contents: [{
              role: 'user',
              parts: [
                {text: payload.prompt},
                ...validatedAttachments.attachments.map((attachment) => ({
                  inlineData: {
                    mimeType: attachment.mimeType,
                    data: attachment.data,
                  },
                })),
              ],
            }],
            generationConfig: {maxOutputTokens: MAX_OUTPUT_TOKENS},
          }),
          signal: controller.signal,
        },
      );
    } catch (error) {
      if (error?.name === 'AbortError') {
        return response(origin, 504, 'GEMINI_TIMEOUT', 'La IA tardó demasiado.');
      }
      return response(origin, 502, 'GEMINI_NO_DISPONIBLE', 'La IA no está disponible.');
    } finally {
      clearTimeout(timeout);
    }

    if (upstream.status === 429) {
      return response(origin, 429, 'GEMINI_SATURADO', 'La IA está temporalmente ocupada.');
    }
    if (!upstream.ok) {
      const status = upstream.status >= 500 ? 502 : 422;
      return response(origin, status, 'GEMINI_RECHAZO', 'La IA rechazó la solicitud.');
    }

    let body;
    try {
      body = await upstream.json();
    } catch (_) {
      return response(origin, 502, 'RESPUESTA_INVALIDA', 'Respuesta inválida de la IA.');
    }
    const text = extractText(body);
    if (!text) {
      return response(origin, 422, 'RESPUESTA_VACIA', 'La IA no generó una respuesta.');
    }
    return success(origin, text);
  },
};
