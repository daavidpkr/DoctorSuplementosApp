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
      .mockResolvedValueOnce(new Response(JSON.stringify({
        users: [{localId: 'usuario-a'}],
      }), {status: 200, headers: {'Content-Type': 'application/json'}}))
      .mockResolvedValueOnce(new Response(JSON.stringify({
        candidates: [{content: {parts: [{text: 'Respuesta correcta'}]}}],
      }), {status: 200, headers: {'Content-Type': 'application/json'}}));
    const response = await worker.fetch(request(), env);
    expect(response.status).toBe(200);
    expect(await response.json()).toEqual({text: 'Respuesta correcta'});
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
