const fs = require('node:fs');
const path = require('node:path');
const {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} = require('@firebase/rules-unit-testing');
const {
  Timestamp,
  deleteDoc,
  doc,
  getDoc,
  setDoc,
  updateDoc,
} = require('firebase/firestore');

const projectId = 'doctor-suplementos-rules-test';
let testEnv;

function perfil(uid, pais = 'ec') {
  return {
    nombre: 'Asesor de prueba',
    fotoBase64: '',
    codigoSocio: 'SOCIO-1',
    telefonoSocio: '999999999',
    propietarioUid: uid,
    pais,
    actualizadoEn: Timestamp.now(),
  };
}

function diagnostico(uid, pais = 'ec') {
  return {
    fecha: '2026-09-18 12:00',
    titulo: 'Diagnostico de prueba',
    nombre: 'Paciente',
    resultado: 'Resultado de prueba',
    datos: {nombre: 'Paciente', sintomas: 'Prueba', pais},
    tipo: 'diagnostico',
    propietarioUid: uid,
    pais,
    creadoEn: Timestamp.now(),
  };
}

function impacto(uid, pais = 'us') {
  return {
    tipo: 'catalogo_afiliado',
    titulo: 'Evento de prueba',
    fecha: '2026-09-18T12:00:00.000',
    datos: {producto: 'Producto de prueba'},
    propietarioUid: uid,
    pais,
    creadoEn: Timestamp.now(),
  };
}

describe('Firestore security rules', () => {
  before(async () => {
    testEnv = await initializeTestEnvironment({
      projectId,
      firestore: {
        rules: fs.readFileSync(
          path.join(__dirname, '..', 'firestore.rules'),
          'utf8',
        ),
      },
    });
  });

  beforeEach(async () => {
    await testEnv.clearFirestore();
  });

  after(async () => {
    await testEnv.cleanup();
  });

  it('rechaza toda lectura y escritura privada sin autenticacion', async () => {
    const db = testEnv.unauthenticatedContext().firestore();

    await assertFails(getDoc(doc(db, 'perfiles_asesores/usuario-a')));
    await assertFails(setDoc(doc(db, 'perfiles_asesores/usuario-a'), perfil('usuario-a')));
    await assertFails(getDoc(doc(db, 'diagnosticos/diagnostico-a')));
    await assertFails(setDoc(doc(db, 'diagnosticos/diagnostico-a'), diagnostico('usuario-a')));
    await assertFails(getDoc(doc(db, 'impacto_4life/impacto-a')));
    await assertFails(setDoc(doc(db, 'impacto_4life/impacto-a'), impacto('usuario-a')));
  });

  it('permite al usuario A crear, leer, modificar y eliminar sus documentos', async () => {
    const db = testEnv.authenticatedContext('usuario-a').firestore();
    const perfilRef = doc(db, 'perfiles_asesores/usuario-a');
    const diagnosticoRef = doc(db, 'diagnosticos/diagnostico-a');
    const impactoRef = doc(db, 'impacto_4life/impacto-a');

    await assertSucceeds(setDoc(perfilRef, perfil('usuario-a')));
    await assertSucceeds(getDoc(perfilRef));
    await assertSucceeds(updateDoc(perfilRef, {nombre: 'Nombre actualizado'}));

    await assertSucceeds(setDoc(diagnosticoRef, diagnostico('usuario-a')));
    await assertSucceeds(getDoc(diagnosticoRef));
    await assertSucceeds(updateDoc(diagnosticoRef, {resultado: 'Actualizado'}));

    await assertSucceeds(setDoc(impactoRef, impacto('usuario-a')));
    await assertSucceeds(getDoc(impactoRef));
    await assertSucceeds(deleteDoc(impactoRef));
    await assertSucceeds(deleteDoc(diagnosticoRef));
    await assertSucceeds(deleteDoc(perfilRef));
  });

  it('impide que el usuario B acceda a documentos del usuario A', async () => {
    await testEnv.withSecurityRulesDisabled(async (context) => {
      const adminDb = context.firestore();
      await setDoc(
        doc(adminDb, 'perfiles_asesores/usuario-a'),
        perfil('usuario-a'),
      );
      await setDoc(
        doc(adminDb, 'diagnosticos/diagnostico-a'),
        diagnostico('usuario-a'),
      );
      await setDoc(
        doc(adminDb, 'impacto_4life/impacto-a'),
        impacto('usuario-a'),
      );
    });

    const dbB = testEnv.authenticatedContext('usuario-b').firestore();
    await assertFails(getDoc(doc(dbB, 'perfiles_asesores/usuario-a')));
    await assertFails(updateDoc(doc(dbB, 'diagnosticos/diagnostico-a'), {resultado: 'Ataque'}));
    await assertFails(deleteDoc(doc(dbB, 'impacto_4life/impacto-a')));
  });

  it('impide falsificar o cambiar el UID propietario', async () => {
    const dbA = testEnv.authenticatedContext('usuario-a').firestore();
    const diagnosticoRef = doc(dbA, 'diagnosticos/diagnostico-a');

    await assertFails(
      setDoc(diagnosticoRef, diagnostico('usuario-b')),
    );
    await assertSucceeds(
      setDoc(diagnosticoRef, diagnostico('usuario-a')),
    );
    await assertFails(
      updateDoc(diagnosticoRef, {propietarioUid: 'usuario-b'}),
    );
    await assertFails(
      setDoc(
        doc(dbA, 'perfiles_asesores/usuario-b'),
        perfil('usuario-a'),
      ),
    );
  });

  it('mantiene inaccesible el documento global legado', async () => {
    await testEnv.withSecurityRulesDisabled(async (context) => {
      await setDoc(
        doc(context.firestore(), 'perfiles_asesores/perfil_principal'),
        {nombre: 'Legado'},
      );
    });

    const dbA = testEnv.authenticatedContext('usuario-a').firestore();
    await assertFails(
      getDoc(doc(dbA, 'perfiles_asesores/perfil_principal')),
    );
    await assertFails(
      setDoc(
        doc(dbA, 'perfiles_asesores/perfil_principal'),
        perfil('usuario-a'),
      ),
    );
  });

  it('valida el pais y separa Ecuador de Estados Unidos', async () => {
    const dbA = testEnv.authenticatedContext('usuario-a').firestore();

    await assertSucceeds(
      setDoc(doc(dbA, 'diagnosticos/ec'), diagnostico('usuario-a', 'ec')),
    );
    await assertSucceeds(
      setDoc(doc(dbA, 'diagnosticos/us'), diagnostico('usuario-a', 'us')),
    );
    await assertFails(
      setDoc(doc(dbA, 'diagnosticos/invalido'), diagnostico('usuario-a', 'xx')),
    );
  });
});
