# Configuracion esperada en Firebase

## Remote Config

Crea estos parametros como valores de tipo texto y publica los cambios:

| Parametro | Ejemplo | Uso |
| --- | --- | --- |
| `version_minima_android` | `1.1.0` | Version minima permitida en Android |
| `version_minima_ios` | `1.1.0` | Version minima permitida en iOS |
| `version_minima_desktop` | `1.1.0` | Version minima para Windows, macOS, Linux y web |
| `url_descarga_android` | `https://play.google.com/store/apps/details?id=...` | Descarga de Android |
| `url_descarga_ios` | `https://apps.apple.com/app/id...` | Descarga de iOS |
| `url_descarga_desktop` | `https://tu-dominio.com/descargas` | Descarga para escritorio o web |

La version se compara matematicamente por `mayor.menor.parche`. Por ejemplo,
`1.9.9` es inferior a `1.10.0`.

Para forzar una actualizacion:

1. Sube y publica la nueva aplicacion.
2. Actualiza la URL de descarga de la plataforma.
3. Cambia su version minima al numero publicado.
4. Publica la plantilla de Remote Config.

No establezcas una version minima antes de que el instalador nuevo este
disponible en la URL, porque los usuarios quedaran bloqueados correctamente.

## Firebase Core

Android ya contiene `android/app/google-services.json`. Para iOS agrega el
archivo `GoogleService-Info.plist` al target Runner antes de publicar esa
plataforma. Las demas plataformas deben conservar opciones validas de Firebase
para el proyecto `doctorsuplementos-4bbb1`.

## Authentication anonima

La aplicacion inicia una sesion anonima y silenciosa antes de usar Firestore.
Para habilitarla manualmente:

1. Abre Firebase Console y selecciona `doctorsuplementos-4bbb1`.
2. Ve a **Build > Authentication** y pulsa **Get started** si corresponde.
3. Abre **Sign-in method**.
4. Selecciona **Anonymous**, activa **Enable** y guarda.
5. En **Settings > Authorized domains**, confirma que el dominio web publicado
   (por ejemplo, `daavidpkr.github.io`) este autorizado.

Si la autenticacion falla o tarda mas de 10 segundos, la aplicacion continua
funcionando con sus datos locales, pero omite toda operacion de Firestore.

## Reglas de Firestore

`firestore.rules` protege las colecciones privadas por UID, valida el pais
`ec`/`us` y deniega por defecto cualquier ruta no declarada. Para probarlas:

```text
npm install --prefix firebase_rules_tests
firebase emulators:exec --only firestore --project doctor-suplementos-rules-test "npm test --prefix firebase_rules_tests"
```

Para desplegarlas manualmente, despues de revisar los resultados:

```text
firebase login
firebase deploy --only firestore:rules --project doctorsuplementos-4bbb1
```

Este repositorio no despliega las reglas automaticamente.

## Datos legados sin propietario

El documento `perfiles_asesores/perfil_principal` no se elimina ni se asigna
automaticamente a ningun usuario. Las reglas nuevas lo dejan inaccesible porque
su ID no coincide con el UID autenticado y no contiene un propietario valido.
Los documentos existentes de `diagnosticos` e `impacto_4life` tampoco tienen
`propietarioUid`; permanecen almacenados, pero el cliente no podra leerlos ni
modificarlos despues de desplegar estas reglas. No despliegues sin respaldarlos
y decidir primero si deben conservarse solo como archivo o migrarse manualmente.

Antes de cualquier migracion manual:

1. Crea o selecciona un bucket privado de Cloud Storage para respaldos.
2. Ejecuta un respaldo administrado de la coleccion, sin borrar el origen:

```text
gcloud firestore export gs://NOMBRE_BUCKET_PRIVADO/respaldo-firestore-FECHA \
  --project=doctorsuplementos-4bbb1 \
  --collection-ids=perfiles_asesores,diagnosticos,impacto_4life
```

3. Verifica en Firebase Authentication el UID anonimo del asesor correcto.
4. Verifica por un canal independiente que el perfil legado realmente pertenece
   a ese asesor. No uses solo nombre, telefono o codigo como prueba de identidad.
5. Desde una herramienta administrativa de confianza, copia unicamente los
   campos validados del perfil a `perfiles_asesores/{uid}` y agrega:
   `propietarioUid: uid`, `pais: ec|us` y `actualizadoEn` como timestamp.
6. Para cada diagnostico o impacto legado, asigna `propietarioUid` solamente si
   existe evidencia administrativa independiente de su propietario. Conserva el
   ID original, agrega `pais: ec|us` y no migres registros de propiedad dudosa.
7. Confirma con cada asesor que puede usar sus documentos nuevos. Conserva el
   respaldo y los documentos legados hasta que exista una politica de retencion
   aprobada.

No hagas esta migracion desde el cliente Flutter ni mediante reglas temporales
publicas. Los SDK administrativos deben ejecutarse en un entorno seguro.
