# FlashLearn Branding Package

Contains the generated FlashLearn app icon and splash screen plus ready-to-run configuration.

## Files

- assets/flashlearn_icon.png — launcher icon
- assets/flashlearn_splash.png — splash artwork
- flutter_launcher_icons.yaml — launcher icon configuration
- flutter_native_splash.yaml — native splash configuration
- setup_branding.ps1 — automated setup script

## Use

Extract this package into the FlashLearn project folder, then open PowerShell in the project root and run:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\setup_branding.ps1
```

The script installs the required packages, generates launcher icons, generates the native splash screen, cleans the build, and fetches dependencies.
