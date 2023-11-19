function Start-VaultRemoveDirs() {
  param(
    [string]$Source,
    [long]$CreationTime,
    [long]$LastWriteTime,
    [string]$Exclude
  )

  Write-Msg -T 'HL' -M 'Removing Empty Directories'

  do {
    $Dirs = ((Get-ChildItem -LiteralPath "${Source}" -Recurse -Directory)
      | Where-Object { (($_.CreationTime) -lt ((Get-Date).AddSeconds(-$CreationTime))) `
        -and (($_.LastWriteTime) -lt ((Get-Date).AddSeconds(-$LastWriteTime))) }
      | Where-Object { ((Get-ChildItem $_.FullName -Force).Count) -eq 0 }
      | Select-Object -ExpandProperty 'FullName')

    if (-not $Dirs) { Write-Msg -M "No empty directories were found in the '${Source}'!" }

    $Dirs | ForEach-Object {
      $Dir = $_
      Write-Msg -M "[RM] '${Dir}'"
      Remove-Data -P "${Dir}"
    }
  } while ( $Dirs.Count -gt 0 )
}
