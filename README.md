# DoctorSuplementos

Aplicacion Flutter de consulta, asesoria y calculadora para suplementos.

## Generar archivos de escritorio

### Windows

Ejecuta:

```powershell
flutter build windows --release
```

El ejecutable queda en:

```text
build/windows/x64/runner/Release/DoctorSuplementos.exe
```

Para entregar la app, comprime toda la carpeta `Release`, no solo el `.exe`,
porque ahi tambien estan las DLL y assets que necesita.

### macOS

Este build debe hacerse desde una Mac con Xcode instalado:

```bash
flutter build macos --release
```

La app queda en:

```text
build/macos/Build/Products/Release/DoctorSuplementos.app
```
