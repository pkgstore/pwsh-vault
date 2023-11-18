# PowerShell Vault Module

A script for transferring and saving files to Vault (storage directory), while maintaining the structure of the original directory. Can accept various filtering parameters for source files as input.

## Install

```powershell
${MOD} = "Vault"; ${PFX} = "PkgStore"; ${DIR} = "$( (${env:PSModulePath} -split ';')[0] )"; Invoke-WebRequest "https://github.com/pkgstore/pwsh-${MOD}/archive/refs/heads/main.zip" -OutFile "${DIR}\${MOD}.zip"; Expand-Archive -Path "${DIR}\${MOD}.zip" -DestinationPath "${DIR}"; if ( Test-Path -Path "${DIR}\${PFX}.${MOD}" ) { Remove-Item -Path "${DIR}\${PFX}.${MOD}" -Recurse -Force }; Rename-Item -Path "${DIR}\pwsh-${MOD}-main" -NewName "${DIR}\${PFX}.${MOD}"; Remove-Item -Path "${DIR}\${MOD}.zip";
```

## Syntax

For syntax information, enter module info command and get help command.

```powershell
Get-Command -Module 'PkgStore.Vault'
```

```powershell
Get-Help '<COMMAND-NAME>'
```

## Documentation

- [PowerShell Vault](https://lib.onl/ru/articles/2023/10/4c7aba7c-f5a6-589a-9975-fdb16f2e2862/)
