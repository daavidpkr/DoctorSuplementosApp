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
