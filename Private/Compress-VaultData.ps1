function Compress-VaultData() {
  <#
    .SYNOPSIS
    Compressing data.

    .DESCRIPTION
    Compressing the Vault data with compression level 9.
  #>

  param(
    [Alias('P')][string]$Path,
    [Alias('N')][string]$Name,
    [Alias('O')][switch]$Overwrite
  )

  if (-not $Overwrite -and (Test-Data -T 'F' -P "${Path}")) {
    Compress-7z -T '7z' -L 9 -I "${Path}" -O "${Name}"
  }
}
