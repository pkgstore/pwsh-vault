function Start-Vault {
  <#
    .SYNOPSIS
    PowerShell Vault.

    .DESCRIPTION
    The module moves files to Vault based on various criteria.

    .PARAMETER Mode
    Script operation mode:
      'CP' | Coping data from the Source.
      'MV' | Moving data from the Source.
      'RM' | Only removing data from the Source.
    Default: 'MV'.

    .PARAMETER Source
    Path to the source. E.g.: 'C:\Source'.

    .PARAMETER Vault
    Path to the Vault. E.g.: 'D:\Vault'.

    .PARAMETER CreationTime
    Time since file creation (in seconds). E.g.: '5270400'.
    If the time since file creation is greater than the specified value, they will be processed by the script.
    Default: '5270400' (61 day).

    .PARAMETER LastWriteTime
    Time since file modification (in seconds). E.g.: '5270400'.
    If the time since file modification is greater than the specified value, they will be processed by the script.
    Default: '5270400' (61 day).

    .PARAMETER FileSize
    File size check. E.g.: '5kb' / '12mb'.
    If the file size is greater than the specified value, they will be processed by the script.
    Default: '0kb'.

    .PARAMETER Exclude
    Path to the file with exceptions. E.g.: 'C:\Exclude.TXT'.
    The values specified in this file will be ignored by the script. Wildcards are supported.

    .PARAMETER Logs
    Path to the directory with logs. E.g.: 'C:\Logs'.

    .PARAMETER RemoveDirs
    Removing empty directories.
    Default: 'false'.

    .PARAMETER Overwrite
    Overwrite existing files in Vault.
    Default: 'false'.

    .EXAMPLE
    Start-Vault -Source 'C:\Source' -Vault 'D:\Vault'

    .EXAMPLE
    Start-Vault -Source 'C:\Source' -Vault 'D:\Vault' -CreationTime '864000' -LastWriteTime '864000'

    .EXAMPLE
    Start-Vault -Source 'C:\Source' -Vault 'D:\Vault' -CreationTime '864000' -LastWriteTime '864000' -FileSize '32mb'
  #>

  param(
    [ValidateSet('CP', 'MV', 'RM')][Alias('M')][string]$Mode = 'MV',
    [Parameter(Mandatory)][Alias('SRC')][string]$Source,
    [Parameter(Mandatory)][Alias('DST')][string]$Vault,
    [Alias('CT')][long]$CreationTime = 5270400,
    [Alias('WT')][long]$LastWriteTime = $CreationTime,
    [Alias('FS')][string]$FileSize = '0kb',
    [Alias('E')][string]$Exclude = "$(Join-Path (Split-Path $PSScriptRoot -Parent) 'Vault.Exclude.txt')",
    [Alias('L')][string]$Logs = "$(Join-Path (Split-Path $PSScriptRoot -Parent) 'Logs')",
    [Alias('RD')][switch]$RemoveDirs = $false,
    [Alias('O')][switch]$Overwrite = $false
  )

  $TS = "$(Get-Date -Format 'yyyy-MM-dd.HH-mm-ss')"

  Start-Transcript -LiteralPath "${Logs}\$((Get-Date).Year)\$((Get-Date).Month)\${TS}.log"

  $MoveFiles = @{
    Mode = $Mode
    Source = $Source
    Vault = $Vault
    CreationTime = $CreationTime
    LastWriteTime = $LastWriteTime
    FileSize = $FileSize
    Exclude = $Exclude
    Overwrite = $Overwrite
  }

  Start-VaultMoveFiles @MoveFiles

  if ($RemoveDirs) { Start-VaultRemoveDirs }
  Stop-Transcript
}
