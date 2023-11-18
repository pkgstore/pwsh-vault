function Compress-VaultData() {
  param (
    [Alias('P')][string]$Path,
    [Alias('N')][string]$Name,
    [Alias('O')][switch]$Overwrite
  )

  if (-not $Overwrite -and (Test-Data -T 'F' -P "${Path}")) {
    Compress-7z -T '7z' -L 9 -I "${Path}" -O "${Name}"
  }
}
