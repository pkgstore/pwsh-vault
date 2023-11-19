function Start-Vault {
  param(
    [Parameter(HelpMessage="Script operation mode. Default: 'MV'.")]
    [ValidateSet('CP', 'MV', 'RM')]
    [Alias('M')][string]$Mode = 'MV',

    [Parameter(Mandatory, HelpMessage="Path to the source. E.g.: 'C:\Data\Source'.")]
    [Alias('SRC')][string]$Source,

    [Parameter(Mandatory, HelpMessage="Path to the Vault. E.g.: 'C:\Data\Vault'.")]
    [Alias('DST')][string]$Vault,

    [Parameter(HelpMessage="Time since file creation (in seconds). E.g.: '5270400'. Default: 61 day (5270400 sec.).")]
    [Alias('CT')][long]$CreationTime = 5270400,

    [Parameter(HelpMessage="Time since file modification (in seconds). E.g.: '5270400'. Default: 61 day ('5270400' sec.).")]
    [Alias('WT')][long]$LastWriteTime = $CreationTime,

    [Parameter(HelpMessage="File size check. E.g.: '5kb' / '12mb'. Default: '0kb'.")]
    [Alias('FS')][string]$FileSize = '0kb',

    [Parameter(HelpMessage="Path to the file with exceptions. E.g.: 'C:\Data\exclude.txt'.")]
    [Alias('E')][string]$Exclude = "$(Join-Path (Split-Path $PSScriptRoot -Parent) 'Vault.Exclude.txt')",

    [Parameter(HelpMessage="Path to the directory with logs. E.g.: 'C:\Data\Logs'.")]
    [Alias('L')][string]$Logs = "$(Join-Path (Split-Path $PSScriptRoot -Parent) 'Logs')",

    [Parameter(HelpMessage="Removing empty directories.")]
    [Alias('RD')][switch]$RemoveDirs = $false,

    [Parameter(HelpMessage="Overwrite existing files in Vault.")]
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
