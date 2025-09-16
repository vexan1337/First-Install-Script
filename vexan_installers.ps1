    If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator"))
    {Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit}
    $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + " (Administrator)"
    $Host.UI.RawUI.BackgroundColor = "Black"
	$Host.PrivateData.ProgressBackgroundColor = "Black"
    $Host.PrivateData.ProgressForegroundColor = "White"
    Clear-Host

    function Get-FileFromWeb {
    param ([Parameter(Mandatory)][string]$URL, [Parameter(Mandatory)][string]$File)
    function Show-Progress {
    param ([Parameter(Mandatory)][Single]$TotalValue, [Parameter(Mandatory)][Single]$CurrentValue, [Parameter(Mandatory)][string]$ProgressText, [Parameter()][int]$BarSize = 10, [Parameter()][switch]$Complete)
    $percent = $CurrentValue / $TotalValue
    $percentComplete = $percent * 100
    if ($psISE) { Write-Progress "$ProgressText" -id 0 -percentComplete $percentComplete }
    else { Write-Host -NoNewLine "`r$ProgressText $(''.PadRight($BarSize * $percent, [char]9608).PadRight($BarSize, [char]9617)) $($percentComplete.ToString('##0.00').PadLeft(6)) % " }
    }
    try {
    $request = [System.Net.HttpWebRequest]::Create($URL)
    $response = $request.GetResponse()
    if ($response.StatusCode -eq 401 -or $response.StatusCode -eq 403 -or $response.StatusCode -eq 404) { throw "Remote file either doesn't exist, is unauthorized, or is forbidden for '$URL'." }
    if ($File -match '^\.\\') { $File = Join-Path (Get-Location -PSProvider 'FileSystem') ($File -Split '^\.')[1] }
    if ($File -and !(Split-Path $File)) { $File = Join-Path (Get-Location -PSProvider 'FileSystem') $File }
    if ($File) { $fileDirectory = $([System.IO.Path]::GetDirectoryName($File)); if (!(Test-Path($fileDirectory))) { [System.IO.Directory]::CreateDirectory($fileDirectory) | Out-Null } }
    [long]$fullSize = $response.ContentLength
    [byte[]]$buffer = new-object byte[] 1048576
    [long]$total = [long]$count = 0
    $reader = $response.GetResponseStream()
    $writer = new-object System.IO.FileStream $File, 'Create'
    do {
    $count = $reader.Read($buffer, 0, $buffer.Length)
    $writer.Write($buffer, 0, $count)
    $total += $count
    if ($fullSize -gt 0) { Show-Progress -TotalValue $fullSize -CurrentValue $total -ProgressText " $($File.Name)" }
    } while ($count -gt 0)
    }
    finally {
    $reader.Close()
    $writer.Close()
    }
    }

    function show-menu {
	Clear-Host
	Write-Host "Game launchers, programs, drivers and web browsers:"
    Write-Host "-Disable hardware acceleration"
    Write-Host "-Turn off running at startup"
    Write-Host "-Deactivate overlays"
	Write-Host ""
    Write-Host " 1. Exit"
    Write-Host " 2. 7-Zip"
    Write-Host " 3. Beeper"
	Write-Host " 4. Discord"
    Write-Host " 5. DirectX"
    Write-Host " 6. Deluge"
    Write-Host " 7. AMD Driver"
    Write-Host " 8. Zen Browser"
    Write-Host " 9. Brave"
    Write-Host "10. League Of Legends"
    Write-Host "11. foobar2000"
    Write-Host "12. OBS Studio"
	Write-Host "13. UAD Driver"
    Write-Host "14. BCUninstaller"
    Write-Host "15. Steam"
    Write-Host "16. C++"
    Write-Host "17. Valorant"
    Write-Host "18. Everything"
    Write-Host "19. SSL Driver"
    Write-Host "20. TranslucentTB"
    Write-Host "21. Proton Drive"
    Write-Host "22. Proton VPN"
    Write-Host "23. Parsec"
    Write-Host "24. PotPlayer"
    Write-Host "25. GlazeWM"
    Write-Host "26. Reaper"

	              }
	show-menu
    while ($true) {
    $choice = Read-Host " "
    if ($choice -match '^(1[0-7]|[1-9])$') {
    switch ($choice) {
    1 {

Clear-Host
exit

      }
    2 {

Clear-Host
Write-Host "Installing: NanaZip . . ."
# download NanaZip
Get-FileFromWeb -URL "https://github.com/vexan1337/files/raw/main/NanaZip_5.0.1263.0.msixbundle" -File "$env:TEMP\NanaZip.msixbundle"
# install NanaZip
Start-Process -wait "$env:TEMP\NanaZip.msixbundle"
show-menu

      }
    3 {

Clear-Host
Write-Host "Installing: Beeper . . ."
# download beeper
Get-FileFromWeb -URL "https://api.beeper.com/desktop/download/windows/x64/stable/com.automattic.beeper.desktop" -File "$env:TEMP\Beeper.exe"
# install beeper 
Start-Process "$env:TEMP\Beeper.exe"
show-menu

      }
    4 {

Clear-Host
Write-Host "Installing: Discord . . ."
# download discord
Get-FileFromWeb -URL "https://dl.discordapp.net/distro/app/stable/win/x86/1.0.9036/DiscordSetup.exe" -File "$env:TEMP\Discord.exe"
# install discord
Start-Process -wait "$env:TEMP\Discord.exe" -ArgumentList "/s"
show-menu

      }
    5 {

Clear-Host
Write-Host "Installing: Direct X . . ."
# download direct x
Get-FileFromWeb -URL "https://download.microsoft.com/download/8/4/A/84A35BF1-DAFE-4AE8-82AF-AD2AE20B6B14/directx_Jun2010_redist.exe" -File "$env:TEMP\DirectX.exe"
# download 7zip
Get-FileFromWeb -URL "https://github.com/FR33THYFR33THY/files/raw/main/7 Zip.exe" -File "$env:TEMP\7 Zip.exe"
# install 7zip
Start-Process -wait "$env:TEMP\7 Zip.exe" /S
# extract files with 7zip
cmd /c "C:\Program Files\7-Zip\7z.exe" x "$env:TEMP\DirectX.exe" -o"$env:TEMP\DirectX" -y | Out-Null
# install direct x
Start-Process "$env:TEMP\DirectX\DXSETUP.exe"
show-menu

      }
    6 {

Clear-Host
Write-Host "Installing: Deluge . . ."
# download Deluge
Get-FileFromWeb -URL "https://ftp.osuosl.org/pub/deluge/windows/deluge-2.2.0-win64-setup.exe" -File "$env:TEMP\Deluge.exe"
# install Deluge
Start-Process -wait "$env:TEMP\Deluge.exe"
show-menu

      }
    7 {

Clear-Host
Write-Host "Installing: AMD Driver . . ."
# download amd driver
Get-FileFromWeb -URL "https://github.com/FR33THYFR33THY/files/raw/main/AMD%20Driver.exe" -File "$env:TEMP\AMD Driver.exe"
# start amd driver installer
Start-Process "$env:TEMP\AMD Driver.exe"
show-menu

      }
    8 {

Clear-Host
Write-Host "Installing: Zen Browser . . ."
# download Zen Browser
Get-FileFromWeb -URL "https://github.com/zen-browser/desktop/releases/latest/download/zen.installer.exe" -File "$env:TEMP\Zen_Browser.exe"
# install Zen Browser
Start-Process -wait "$env:TEMP\Zen_Browser.exe"
show-menu

      }
    9 {

Clear-Host
Write-Host "Installing: Brave . . ."
# download Brave
Get-FileFromWeb -URL "https://laptop-updates.brave.com/latest/winx64" -File "$env:TEMP\Brave.exe"
# install Brave
Start-Process -wait "$env:TEMP\Brave.exe"
show-menu

      }
   10 {

Clear-Host
Write-Host "Installing: League Of Legends . . ."
# download league of legends
Get-FileFromWeb -URL "https://lol.secure.dyn.riotcdn.net/channels/public/x/installer/current/live.euw.exe" -File "$env:TEMP\League Of Legends.exe"
# install league of legends
Start-Process "$env:TEMP\League Of Legends.exe"
show-menu

      }
   11 {

Clear-Host
Write-Host "Installing: foobar2000 . . ."
# download foobar2000
Get-FileFromWeb -URL "https://www.foobar2000.org/files/foobar2000_v2.1.2.exe" -File "$env:TEMP\foobar2000.exe"
# install foobar2000
Start-Process -wait "$env:TEMP\foobar2000.exe"
show-menu

      }
   12 {

Clear-Host
Write-Host "Installing: OBS Studio . . ."
# download obs studio
Get-FileFromWeb -URL "https://github.com/obsproject/obs-studio/releases/download/31.0.2/OBS-Studio-31.0.2-Windows-Installer.exe" -File "$env:TEMP\OBS Studio.exe"
# install obs studio
Start-Process -wait "$env:TEMP\OBS Studio.exe" -ArgumentList "/S"
show-menu

      }
   13 {

Clear-Host
Write-Host "Installing: UAD Driver . . ."
# download UAD Driver
Get-FileFromWeb -URL "https://www.uaudio.com/apps/uaconnect/win/installer" -File "$env:TEMP\UAD_Driver.exe"
# install UAD Driver
Start-Process -wait "$env:TEMP\UAD_Driver.exe"
show-menu

      }
   14 {

Clear-Host
Write-Host "Installing: BCUninstaller . . ."
# download BCUninstaller
Get-FileFromWeb -URL "https://github.com/Klocman/Bulk-Crap-Uninstaller/releases/download/v5.9/BCUninstaller_5.9.0_setup.exe" -File "$env:TEMP\BCUninstaller.exe"
# install BCUninstaller
Start-Process -wait "$env:TEMP\BCUninstaller.exe"
show-menu

      }
   15 {

Clear-Host
Write-Host "Installing: Steam . . ."
# download steam
Get-FileFromWeb -URL "https://cdn.cloudflare.steamstatic.com/client/installer/SteamSetup.exe" -File "$env:TEMP\Steam.exe"
# install steam
Start-Process -wait "$env:TEMP\Steam.exe" -ArgumentList "/S"
show-menu

      }
   16 {

Clear-Host
Write-Host "Installing: C ++ . . ."
# download c++ installers
Get-FileFromWeb -URL "https://download.microsoft.com/download/8/B/4/8B42259F-5D70-43F4-AC2E-4B208FD8D66A/vcredist_x86.EXE" -File "$env:TEMP\vcredist2005_x86.exe"
Get-FileFromWeb -URL "https://download.microsoft.com/download/8/B/4/8B42259F-5D70-43F4-AC2E-4B208FD8D66A/vcredist_x64.EXE" -File "$env:TEMP\vcredist2005_x64.exe"
Get-FileFromWeb -URL "https://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x86.exe" -File "$env:TEMP\vcredist2008_x86.exe"
Get-FileFromWeb -URL "https://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x64.exe" -File "$env:TEMP\vcredist2008_x64.exe"
Get-FileFromWeb -URL "https://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x86.exe" -File "$env:TEMP\vcredist2010_x86.exe" 
Get-FileFromWeb -URL "https://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x64.exe" -File "$env:TEMP\vcredist2010_x64.exe"
Get-FileFromWeb -URL "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe" -File "$env:TEMP\vcredist2012_x86.exe"
Get-FileFromWeb -URL "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x64.exe" -File "$env:TEMP\vcredist2012_x64.exe"
Get-FileFromWeb -URL "https://aka.ms/highdpimfc2013x86enu" -File "$env:TEMP\vcredist2013_x86.exe"
Get-FileFromWeb -URL "https://aka.ms/highdpimfc2013x64enu" -File "$env:TEMP\vcredist2013_x64.exe"
Get-FileFromWeb -URL "https://aka.ms/vs/17/release/vc_redist.x86.exe" -File "$env:TEMP\vcredist2015_2017_2019_2022_x86.exe"
Get-FileFromWeb -URL "https://aka.ms/vs/17/release/vc_redist.x64.exe" -File "$env:TEMP\vcredist2015_2017_2019_2022_x64.exe"
# start c++ installers
Start-Process -wait "$env:TEMP\vcredist2005_x86.exe" -ArgumentList "/q"
Start-Process -wait "$env:TEMP\vcredist2005_x64.exe" -ArgumentList "/q"
Start-Process -wait "$env:TEMP\vcredist2008_x86.exe" -ArgumentList "/qb"
Start-Process -wait "$env:TEMP\vcredist2008_x64.exe" -ArgumentList "/qb"
Start-Process -wait "$env:TEMP\vcredist2010_x86.exe" -ArgumentList "/passive /norestart"
Start-Process -wait "$env:TEMP\vcredist2010_x64.exe" -ArgumentList "/passive /norestart"
Start-Process -wait "$env:TEMP\vcredist2012_x86.exe" -ArgumentList "/passive /norestart"
Start-Process -wait "$env:TEMP\vcredist2012_x64.exe" -ArgumentList "/passive /norestart"
Start-Process -wait "$env:TEMP\vcredist2013_x86.exe" -ArgumentList "/passive /norestart"
Start-Process -wait "$env:TEMP\vcredist2013_x64.exe" -ArgumentList "/passive /norestart"
Start-Process -wait "$env:TEMP\vcredist2015_2017_2019_2022_x86.exe" -ArgumentList "/passive /norestart"
Start-Process -wait "$env:TEMP\vcredist2015_2017_2019_2022_x64.exe" -ArgumentList "/passive /norestart"
show-menu

      }
   17 {

Clear-Host
Write-Host "Installing: Valorant . . ."
# download valorant
Get-FileFromWeb -URL "https://valorant.secure.dyn.riotcdn.net/channels/public/x/installer/current/live.live.ap.exe" -File "$env:TEMP\Valorant.exe"
# install valorant 
Start-Process "$env:TEMP\Valorant.exe"
show-menu

      }
   18 {

Clear-Host
Write-Host "Installing: Everything . . ."
# download Everything
Get-FileFromWeb -URL "https://www.voidtools.com/Everything-1.4.1.1028.x64-Setup.exe" -File "$env:TEMP\Everything.exe"
# install Everything
Start-Process "$env:TEMP\Everything.exe"
show-menu

      }
   19 {

Clear-Host
Write-Host "Installing: SSL Driver . . ."
# download SSL Driver
Get-FileFromWeb -URL "https://github.com/vexan1337/files/raw/main/SolidStateLogic_UsbAudio.exe" -File "$env:TEMP\SSL.exe"
# install SSL Driver
Start-Process "$env:TEMP\SSL.exe"
show-menu

      }
   20 {

Clear-Host
Write-Host "Installing: TranslucentTB . . ."
# download TranslucentTB
Get-FileFromWeb -URL "https://github.com/TranslucentTB/TranslucentTB/releases/download/2025.1/TranslucentTB.appinstaller" -File "$env:TEMP\TranslucentTB.appinstaller"
# install TranslucentTB
Start-Process "$env:TEMP\TranslucentTB.appinstaller"
show-menu

      }
   21 {

Clear-Host
Write-Host "Installing: Proton Drive . . ."
# download Proton Drive
Get-FileFromWeb -URL "https://proton.me/download/drive/windows/1.11.3/x64/Proton%20Drive%20Setup%201.11.3.exe" -File "$env:TEMP\ProtonDrive.exe"
# install Proton Drive
Start-Process "$env:TEMP\ProtonDrive.exe"
show-menu

      }
   22 {

Clear-Host
Write-Host "Installing: Proton VPN . . ."
# download Proton VPN
Get-FileFromWeb -URL "https://vpn.protondownload.com/download/ProtonVPN_v4.3.1_x64.exe" -File "$env:TEMP\ProtonVPN.exe"
# install Proton VPN
Start-Process "$env:TEMP\ProtonVPN.exe"
show-menu

      }
   23 {

Clear-Host
Write-Host "Installing: Parsec . . ."
# download Parsec
Get-FileFromWeb -URL "https://builds.parsec.app/package/parsec-windows.exe" -File "$env:TEMP\Parsec.exe"
# install Parsec
Start-Process "$env:TEMP\Parsec.exe"
show-menu

      }
   24 {

Clear-Host
Write-Host "Installing: PotPlayer . . ."
# download PotPlayer
Get-FileFromWeb -URL "https://t1.daumcdn.net/potplayer/PotPlayer/Version/Latest/PotPlayerSetup64.exe" -File "$env:TEMP\PotPlayer.exe"
# install PotPlayer
Start-Process "$env:TEMP\PotPlayer.exe"
show-menu

      }
   25 {

Clear-Host
Write-Host "Installing: GlazeWM . . ."
# download GlazeWM
Get-FileFromWeb -URL "https://github.com/glzr-io/glazewm/releases/download/v3.9.1/standalone-glazewm-v3.9.1-x64.msi" -File "$env:TEMP\GlazeWM.msi"
# install GlazeWM
Start-Process "$env:TEMP\GlazeWM.msi"
show-menu

      }
   26 {

Clear-Host
Write-Host "Installing: Reaper . . ."
# download Reaper
Get-FileFromWeb -URL "https://www.reaper.fm/files/7.x/reaper745_x64-install.exe" -File "$env:TEMP\Reaper.exe"
# install Reaper
Start-Process "$env:TEMP\Reaper.exe"
show-menu

      }

    } } else { Write-Host "Invalid input. Please select a valid option (1-17)." } }