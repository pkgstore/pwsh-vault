function Start-VaultMoveFiles() {
  param (
    [string]$Mode,
    [string]$Source,
    [string]$Vault,
    [long]$CreationTime,
    [long]$LastWriteTime,
    [string]$FileSize,
    [string]$Exclude,
    [switch]$Overwrite
  )

  $UTS = "$([DateTimeOffset]::Now.ToUnixTimeSeconds())"
  $NL = [Environment]::NewLine

  Write-Msg -T 'HL' -M 'Moving Files to Vault'

  $Files = ((Get-ChildItem -LiteralPath "${Source}" -Recurse -File -Exclude (Get-Content "${Exclude}"))
    | Where-Object { (($_.CreationTime) -lt ((Get-Date).AddSeconds(-$CreationTime))) `
      -and (($_.LastWriteTime) -lt ((Get-Date).AddSeconds(-$LastWriteTime))) }
    | Where-Object { ($_.Length) -ge "${FileSize}" })

  if (-not $Files) { Write-Msg -M "Required files were not found in the '${Source}'!" }

  $Files | ForEach-Object {
    $File = $_

    if (($File.FullName.Length) -ge 245) {
      Write-Msg -T 'W' -M "Over 250 characters in path! Skip:${NL}'${File}'"
      continue
    }

    $PathSRC = @("$($File.FullName)")
    $PathDST = @("$($File.FullName)", "$($File.DirectoryName)").ForEach({ $_.Remove(0, $Source.Length) })
    $PathDST[0] = (${Vault} | Join-Path -ChildPath "$($PathDST[0])")

    switch ($Mode) {
      'CP' {
        New-Data -T 'D' -P "${Vault}" -N "$($PathDST[1])" | Out-Null
        Compress-VaultData -P "$($PathDST[0])" -N "$($PathDST[0]).${UTS}.7z" -O=$Overwrite

        Write-Msg -M "[CP] '$($PathSRC[0])' -> '$($PathDST[0])'"
        Copy-Data -S "$($PathSRC[0])" -D "$($PathDST[0])"
      }
      'MV' {
        New-Data -T 'D' -P "${Vault}" -N "$($PathDST[1])" | Out-Null
        Compress-VaultData -P "$($PathDST[0])" -N "$($PathDST[0]).${UTS}.7z" -O=$Overwrite

        Write-Msg -M "[MV] '$($PathSRC[0])' -> '$($PathDST[0])'"
        Move-Data -S "$($PathSRC[0])" -D "$($PathDST[0])"
      }
      'RM' {
        Write-Msg -M "[RM] '$($PathSRC[0])'"
        Remove-Data -p "$($PathSRC[0])"
      }
    }
  }
}
