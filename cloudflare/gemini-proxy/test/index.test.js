import {afterEach, describe, expect, it, vi} from 'vitest';
import worker from '../src/index.js';

const origin = 'https://daavidpkr.github.io';
const env = {GEMINI_API_KEY: 'test-gemini', FIREBASE_API_KEY: 'test-firebase'};

function token({expired = false} = {}) {
  const now = Math.floor(Date.now() / 1000);
  const encode = (value) => Buffer.from(JSON.stringify(value)).toString('base64url');
  return `${encode({alg: 'RS256', kid: 'test'})}.${encode({
    aud: 'doctorsuplementos-4bbb1',
    iss: 'https://securetoken.google.com/doctorsuplementos-4bbb1',
    sub: 'usuario-a',
    iat: now - 10,
    exp: expired ? now - 1 : now + 3600,
    firebase: {sign_in_provider: 'anonymous'},
  })}.signature`;
}

function request({
  requestOrigin = origin,
  authorization = `Bearer ${token()}`,
  body = JSON.stringify({prompt: 'Texto de prueba'}),
  contentType = 'application/json',
  method = 'POST',
} = {}) {
  return new Request('https://worker.example/v1/generate', {
    method,
    headers: {
      Origin: requestOrigin,
      Authorization: authorization,
      'Content-Type': contentType,
    },
    body: method === 'POST' ? body : undefined,
  });
}

function validIdentity() {
  return new Response(JSON.stringify({users: [{localId: 'usuario-a'}]}), {
    status: 200,
    headers: {'Content-Type': 'application/json'},
  });
}

afterEach(() => vi.restoreAllMocks());

describe('Gemini proxy', () => {
  it('rechaza origen no autorizado', async () => {
    const response = await worker.fetch(request({requestOrigin: 'https://evil.example'}), env);
    expect(response.status).toBe(403);
  });

  it('rechaza token ausente', async () => {
    const response = await worker.fetch(request({authorization: ''}), env);
    expect(response.status).toBe(401);
  });

  it('rechaza token expirado antes de consultar Gemini', async () => {
    const fetchMock = vi.spyOn(globalThis, 'fetch');
    const response = await worker.fetch(
      request({authorization: `Bearer ${token({expired: true})}`}),
      env,
    );
    expect(response.status).toBe(401);
    expect(fetchMock).not.toHaveBeenCalled();
  });

  it('rechaza token que Identity Toolkit no valida', async () => {
    vi.spyOn(globalThis, 'fetch').mockResolvedValueOnce(
      new Response('{}', {status: 400}),
    );
    const response = await worker.fetch(request(), env);
    expect(response.status).toBe(401);
  });

  it('rechaza tipo de contenido y payload no admitidos', async () => {
    expect((await worker.fetch(request({contentType: 'text/plain'}), env)).status)
      .toBe(415);
    vi.spyOn(globalThis, 'fetch').mockResolvedValueOnce(
      new Response(JSON.stringify({users: [{localId: 'usuario-a'}]}), {
        status: 200,
        headers: {'Content-Type': 'application/json'},
      }),
    );
    expect((await worker.fetch(request({body: JSON.stringify({prompt: 'x', extra: true})}), env)).status)
      .toBe(400);
  });

  it('valida token y devuelve solo el texto de Gemini', async () => {
    vi.spyOn(globalThis, 'fetch')
      .mockResolvedValueOnce(validIdentity())
      .mockResolvedValueOnce(new Response(JSON.stringify({
        candidates: [{content: {parts: [{text: 'Respuesta correcta'}]}}],
      }), {status: 200, headers: {'Content-Type': 'application/json'}}));
    const response = await worker.fetch(request(), env);
    expect(response.status).toBe(200);
    expect(await response.json()).toEqual({text: 'Respuesta correcta'});
  });

  it('acepta Android sin Origin y reenvia adjuntos inline admitidos', async () => {
    let upstreamBody;
    vi.spyOn(globalThis, 'fetch')
      .mockResolvedValueOnce(validIdentity())
      .mockImplementationOnce(async (_url, options) => {
        upstreamBody = JSON.parse(options.body);
        return new Response(JSON.stringify({
          candidates: [{content: {parts: [{text: 'Archivo analizado'}]}}],
        }), {status: 200, headers: {'Content-Type': 'application/json'}});
      });
    const androidRequest = request({
      requestOrigin: '',
      body: JSON.stringify({
        prompt: 'Analiza el archivo',
        attachments: [{
          mimeType: 'application/pdf',
          data: Buffer.from('%PDF-prueba').toString('base64'),
        }],
      }),
    });

    const workerResponse = await worker.fetch(androidRequest, env);

    expect(workerResponse.status).toBe(200);
    expect(upstreamBody.contents[0].parts).toEqual([
      {text: 'Analiza el archivo'},
      {inlineData: {
        mimeType: 'application/pdf',
        data: Buffer.from('%PDF-prueba').toString('base64'),
      }},
    ]);
    expect(workerResponse.headers.has('Access-Control-Allow-Origin')).toBe(false);
  });

  it('rechaza MIME y Base64 invalidos antes de consultar Gemini', async () => {
    const fetchMock = vi.spyOn(globalThis, 'fetch')
      .mockResolvedValue(validIdentity());
    const badMime = await worker.fetch(request({body: JSON.stringify({
      prompt: 'x',
      attachments: [{mimeType: 'text/plain', data: 'YWJj'}],
    })}), env);
    expect(badMime.status).toBe(400);
    expect(fetchMock).toHaveBeenCalledTimes(1);

    fetchMock.mockClear().mockResolvedValue(validIdentity());
    const badBase64 = await worker.fetch(request({body: JSON.stringify({
      prompt: 'x',
      attachments: [{mimeType: 'image/jpeg', data: 'base64-no-valido'}],
    })}), env);
    expect(badBase64.status).toBe(400);
    expect(fetchMock).toHaveBeenCalledTimes(1);
    expect(JSON.stringify(await badBase64.json())).not.toContain('base64-no-valido');
  });

  it('admite las firmas de imagen, PDF y audio usadas por Flutter', async () => {
    const samples = [
      ['image/jpeg', [0xFF, 0xD8, 0xFF, 0x00]],
      ['image/png', [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]],
      ['image/webp', [0x52, 0x49, 0x46, 0x46, 0, 0, 0, 0, 0x57, 0x45, 0x42, 0x50]],
      ['application/pdf', [0x25, 0x50, 0x44, 0x46, 0x2D]],
      ['audio/mp4', [0, 0, 0, 0, 0x66, 0x74, 0x79, 0x70]],
    ];
    vi.spyOn(globalThis, 'fetch').mockImplementation(async (url) => {
      if (String(url).includes('identitytoolkit')) return validIdentity();
      return new Response(JSON.stringify({
        candidates: [{content: {parts: [{text: 'OK'}]}}],
      }), {status: 200, headers: {'Content-Type': 'application/json'}});
    });

    for (const [mimeType, bytes] of samples) {
      const result = await worker.fetch(request({body: JSON.stringify({
        prompt: 'Analiza',
        attachments: [{mimeType, data: Buffer.from(bytes).toString('base64')}],
      })}), env);
      expect(result.status, mimeType).toBe(200);
    }
  });

  it('sanitiza errores y diferencia saturacion de Gemini', async () => {
    vi.spyOn(globalThis, 'fetch')
      .mockResolvedValueOnce(new Response(JSON.stringify({
        users: [{localId: 'usuario-a'}],
      }), {status: 200, headers: {'Content-Type': 'application/json'}}))
      .mockResolvedValueOnce(new Response('detalle privado', {status: 429}));
    const response = await worker.fetch(request(), env);
    expect(response.status).toBe(429);
    expect(JSON.stringify(await response.json())).not.toContain('detalle privado');
  });

  it('devuelve timeout sanitizado', async () => {
    const abortError = new Error('timeout privado');
    abortError.name = 'AbortError';
    vi.spyOn(globalThis, 'fetch')
      .mockResolvedValueOnce(new Response(JSON.stringify({
        users: [{localId: 'usuario-a'}],
      }), {status: 200, headers: {'Content-Type': 'application/json'}}))
      .mockRejectedValueOnce(abortError);
    const response = await worker.fetch(request(), env);
    expect(response.status).toBe(504);
    expect(JSON.stringify(await response.json())).not.toContain('privado');
  });
});
