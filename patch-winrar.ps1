$ErrorActionPreference = 'Stop'

$KeyLines = @(
    'RAR registration data'
    'WinRAR'
    'Unlimited Company License'
    'UID=4b914fb772c8376bf571'
    '6412212250f5711ad072cf351cfa39e2851192daf8a362681bbb1d'
    'cd48da1d14d995f0bbf960fce6cb5ffde62890079861be57638717'
    '7131ced835ed65cc743d9777f2ea71a8e32c7e593cf66794343565'
    'b41bcf56929486b8bcdac33d50ecf773996052598f1f556defffbd'
    '982fbe71e93df6b6346c37a3890f3c7edc65d7f5455470d13d1190'
    '6e6fb824bcf25f155547b5fc41901ad58c0992f570be1cf5608ba9'
    'aef69d48c864bcd72d15163897773d314187f6a9af350808719796'
)

$KeyName = 'rarreg.key'

# Windows 9x Classic Colors
$Colors = @{
    BgDark       = [System.Drawing.Color]::Black
    BgPanel      = [System.Drawing.Color]::FromArgb(192, 192, 192)
    BgLight      = [System.Drawing.Color]::FromArgb(224, 224, 224)
    BgDarkGray   = [System.Drawing.Color]::FromArgb(128, 128, 128)
    TextWhite    = [System.Drawing.Color]::White
    TextBlack    = [System.Drawing.Color]::Black
    Highlight    = [System.Drawing.Color]::FromArgb(0, 0, 128)
    BtnFace      = [System.Drawing.Color]::FromArgb(192, 192, 192)
    BtnHighlight = [System.Drawing.Color]::White
    BtnShadow    = [System.Drawing.Color]::FromArgb(128, 128, 128)
    BtnDark      = [System.Drawing.Color]::FromArgb(64, 64, 64)
    NeonCyan     = [System.Drawing.Color]::FromArgb(0, 255, 255)
    NeonGreen    = [System.Drawing.Color]::FromArgb(0, 255, 128)
    NeonPink     = [System.Drawing.Color]::FromArgb(255, 0, 255)
    NeonYellow   = [System.Drawing.Color]::FromArgb(255, 255, 0)
}

function Find-WinRAR {
    $Candidates = @(
        'C:\Program Files\WinRAR'
        'C:\Program Files (x86)\WinRAR'
        (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*' -ErrorAction SilentlyContinue | 
            Where-Object { $_.DisplayName -like '*WinRAR*' } | Select-Object -ExpandProperty InstallLocation -First 1)
        (Get-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' -ErrorAction SilentlyContinue | 
            Where-Object { $_.DisplayName -like '*WinRAR*' } | Select-Object -ExpandProperty InstallLocation -First 1)
    )
    foreach ($Path in $Candidates) {
        if ($Path -and (Test-Path (Join-Path $Path 'WinRAR.exe'))) {
            return $Path
        }
    }
    return $Candidates[0]
}

function Test-Admin {
    $id = [Security.Principal.WindowsIdentity]::GetCurrent()
    $pr = New-Object Security.Principal.WindowsPrincipal($id)
    return $pr.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function Write-KeyFile {
    param([string]$Dir)
    $dest = Join-Path $Dir $KeyName
    if (-not (Test-Path $Dir)) {
        New-Item -Path $Dir -ItemType Directory -Force | Out-Null
    }
    Set-Content -Path $dest -Value $KeyLines -Encoding ASCII -Force
}

# Win9x 3D Border Effect function
function Add-Win9xBorder($Control, $Inset = $false) {
    $Control.BorderStyle = 'None'
    # Outer bevel will be drawn by the panel itself
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

if (-not (Test-Admin)) {
    [System.Windows.Forms.MessageBox]::Show(
        "This keygen requires Administrator privileges.`n`nPlease run again as Administrator.",
        "WinRAR Keygen",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Warning
    ) | Out-Null
    exit 1
}

[System.Windows.Forms.Application]::EnableVisualStyles()

# Main Form - Win9x Style
$form = New-Object System.Windows.Forms.Form
$form.Text = "WinRAR Keygen v3.0"
$form.Size = New-Object System.Drawing.Size(560, 560)
$form.StartPosition = 'CenterScreen'
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false
$form.MinimizeBox = $false
$form.BackColor = $Colors.BgPanel
$form.Font = New-Object System.Drawing.Font('MS Sans Serif', 8)

# Outer 3D border (raised)
$outerPanel = New-Object System.Windows.Forms.Panel
$outerPanel.Size = New-Object System.Drawing.Size(556, 556)
$outerPanel.Location = New-Object System.Drawing.Point(2, 2)
$outerPanel.BackColor = $Colors.BgPanel
$outerPanel.BorderStyle = 'Fixed3D'
$form.Controls.Add($outerPanel)

# Starfield/Logo area (black background)
$logoPanel = New-Object System.Windows.Forms.Panel
$logoPanel.Size = New-Object System.Drawing.Size(526, 180)
$logoPanel.Location = New-Object System.Drawing.Point(10, 10)
$logoPanel.BackColor = $Colors.BgDark
$outerPanel.Controls.Add($logoPanel)

# Logo Text - WinRAR
$logoLabel = New-Object System.Windows.Forms.Label
$logoLabel.Text = "WinRAR"
$logoLabel.Font = New-Object System.Drawing.Font('Impact', 36, [System.Drawing.FontStyle]::Bold)
$logoLabel.AutoSize = $true
$logoLabel.Location = New-Object System.Drawing.Point(150, 15)
$logoLabel.ForeColor = [System.Drawing.Color]::FromArgb(255, 200, 100)
$logoPanel.Controls.Add($logoLabel)

# By BaTTi CoRp
$battiLabel = New-Object System.Windows.Forms.Label
$battiLabel.Text = "By BaTTi CoRp"
$battiLabel.Font = New-Object System.Drawing.Font('Impact', 16, [System.Drawing.FontStyle]::Italic)
$battiLabel.AutoSize = $true
$battiLabel.Location = New-Object System.Drawing.Point(170, 85)
$battiLabel.ForeColor = [System.Drawing.Color]::FromArgb(255, 100, 200)
$logoPanel.Controls.Add($battiLabel)

# KEYGEN label
$keygenLabel = New-Object System.Windows.Forms.Label
$keygenLabel.Text = "KEYGEN"
$keygenLabel.Font = New-Object System.Drawing.Font('Impact', 12, [System.Drawing.FontStyle]::Bold)
$keygenLabel.AutoSize = $true
$keygenLabel.Location = New-Object System.Drawing.Point(350, 88)
$keygenLabel.ForeColor = $Colors.NeonGreen
$logoPanel.Controls.Add($keygenLabel)

# Version label
$verLabel = New-Object System.Windows.Forms.Label
$verLabel.Text = "v3.0"
$verLabel.Font = New-Object System.Drawing.Font('MS Sans Serif', 7)
$verLabel.ForeColor = $Colors.NeonCyan
$verLabel.AutoSize = $true
$verLabel.Location = New-Object System.Drawing.Point(445, 150)
$logoPanel.Controls.Add($verLabel)

# Color animation timer for logo
$colorTimer = New-Object System.Windows.Forms.Timer
$colorTimer.Interval = 200
$script:colorIndex = 0
$neonColors = @(
    [System.Drawing.Color]::FromArgb(255, 200, 100),
    [System.Drawing.Color]::FromArgb(255, 255, 0),
    [System.Drawing.Color]::FromArgb(0, 255, 255),
    [System.Drawing.Color]::FromArgb(255, 0, 255),
    [System.Drawing.Color]::FromArgb(0, 255, 128)
)
$colorTimer.Add_Tick({
    $script:colorIndex = ($script:colorIndex + 1) % $neonColors.Length
    $logoLabel.ForeColor = $neonColors[$script:colorIndex]
})
$colorTimer.Start()

# Main content area with 3D sunken border
$contentPanel = New-Object System.Windows.Forms.Panel
$contentPanel.Size = New-Object System.Drawing.Size(526, 260)
$contentPanel.Location = New-Object System.Drawing.Point(10, 198)
$contentPanel.BackColor = $Colors.BgPanel
$contentPanel.BorderStyle = 'Fixed3D'
$outerPanel.Controls.Add($contentPanel)

# Program label and dropdown
$yPos = 12
$progLabel = New-Object System.Windows.Forms.Label
$progLabel.Text = "Program:"
$progLabel.Font = New-Object System.Drawing.Font('MS Sans Serif', 8, [System.Drawing.FontStyle]::Bold)
$progLabel.ForeColor = $Colors.TextBlack
$progLabel.AutoSize = $true
$progLabel.Location = New-Object System.Drawing.Point(10, $yPos)
$contentPanel.Controls.Add($progLabel)

# Program text box (read-only, looks like dropdown)
$progBox = New-Object System.Windows.Forms.TextBox
$progBox.Size = New-Object System.Drawing.Size(390, 20)
$progBox.Location = New-Object System.Drawing.Point(10, ($yPos + 18))
$progBox.Text = "WinRAR Unlimited License Edition"
$progBox.ReadOnly = $true
$progBox.BackColor = $Colors.TextWhite
$progBox.ForeColor = $Colors.TextBlack
$progBox.BorderStyle = 'Fixed3D'
$progBox.Font = New-Object System.Drawing.Font('MS Sans Serif', 8)
$contentPanel.Controls.Add($progBox)

# Dropdown button (decorative)
$dropBtn = New-Object System.Windows.Forms.Button
$dropBtn.Size = New-Object System.Drawing.Size(18, 20)
$dropBtn.Location = New-Object System.Drawing.Point(400, ($yPos + 18))
$dropBtn.Text = "6"  # Down arrow character
$dropBtn.Font = New-Object System.Drawing.Font('Marlett', 8)
$dropBtn.FlatStyle = 'Flat'
$dropBtn.BackColor = $Colors.BtnFace
$dropBtn.Enabled = $false
$contentPanel.Controls.Add($dropBtn)

# Installation Path
$yPos = 55
$pathLabel = New-Object System.Windows.Forms.Label
$pathLabel.Text = "Installation Path:"
$pathLabel.Font = New-Object System.Drawing.Font('MS Sans Serif', 8, [System.Drawing.FontStyle]::Bold)
$pathLabel.ForeColor = $Colors.TextBlack
$pathLabel.AutoSize = $true
$pathLabel.Location = New-Object System.Drawing.Point(10, $yPos)
$contentPanel.Controls.Add($pathLabel)

$pathBox = New-Object System.Windows.Forms.TextBox
$pathBox.Size = New-Object System.Drawing.Size(380, 20)
$pathBox.Location = New-Object System.Drawing.Point(10, ($yPos + 18))
$pathBox.Text = (Find-WinRAR)
$pathBox.BackColor = $Colors.TextWhite
$pathBox.ForeColor = $Colors.TextBlack
$pathBox.BorderStyle = 'Fixed3D'
$pathBox.Font = New-Object System.Drawing.Font('MS Sans Serif', 8)
$contentPanel.Controls.Add($pathBox)

# Browse button (Win9x style)
$browseBtn = New-Object System.Windows.Forms.Button
$browseBtn.Text = "Browse..."
$browseBtn.Size = New-Object System.Drawing.Size(75, 22)
$browseBtn.Location = New-Object System.Drawing.Point(440, ($yPos + 17))
$browseBtn.FlatStyle = 'Flat'
$browseBtn.BackColor = $Colors.BtnFace
$browseBtn.Font = New-Object System.Drawing.Font('MS Sans Serif', 8)
$contentPanel.Controls.Add($browseBtn)

# License Key fields
$yPos = 105
$keyLabel = New-Object System.Windows.Forms.Label
$keyLabel.Text = "License Key:"
$keyLabel.Font = New-Object System.Drawing.Font('MS Sans Serif', 8, [System.Drawing.FontStyle]::Bold)
$keyLabel.ForeColor = $Colors.TextBlack
$keyLabel.AutoSize = $true
$keyLabel.Location = New-Object System.Drawing.Point(10, $yPos)
$contentPanel.Controls.Add($keyLabel)

# Key display box (sunken, read-only)
$keyBox = New-Object System.Windows.Forms.TextBox
$keyBox.Size = New-Object System.Drawing.Size(505, 20)
$keyBox.Location = New-Object System.Drawing.Point(10, ($yPos + 18))
$keyBox.Text = "XXXX-XXXX-XXXX-XXXX-XXXX-XXXX"
$keyBox.ReadOnly = $true
$keyBox.BackColor = $Colors.TextWhite
$keyBox.ForeColor = $Colors.TextBlack
$keyBox.BorderStyle = 'Fixed3D'
$keyBox.Font = New-Object System.Drawing.Font('Courier New', 9)
$keyBox.TextAlign = 'Center'
$contentPanel.Controls.Add($keyBox)

# Status label
$yPos = 155
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = "Status:"
$statusLabel.Font = New-Object System.Drawing.Font('MS Sans Serif', 8, [System.Drawing.FontStyle]::Bold)
$statusLabel.ForeColor = $Colors.TextBlack
$statusLabel.AutoSize = $true
$statusLabel.Location = New-Object System.Drawing.Point(10, $yPos)
$contentPanel.Controls.Add($statusLabel)

$statusBox = New-Object System.Windows.Forms.TextBox
$statusBox.Size = New-Object System.Drawing.Size(505, 20)
$statusBox.Location = New-Object System.Drawing.Point(10, ($yPos + 18))
$statusBox.Text = "Ready to generate license..."
$statusBox.ReadOnly = $true
$statusBox.BackColor = $Colors.TextWhite
$statusBox.ForeColor = [System.Drawing.Color]::FromArgb(0, 128, 0)
$statusBox.BorderStyle = 'Fixed3D'
$statusBox.Font = New-Object System.Drawing.Font('MS Sans Serif', 8)
$contentPanel.Controls.Add($statusBox)

# Info text
$infoLabel = New-Object System.Windows.Forms.Label
$infoLabel.Text = "Click Generate to create your license key. Restart WinRAR after generating."
$infoLabel.Font = New-Object System.Drawing.Font('MS Sans Serif', 7)
$infoLabel.ForeColor = $Colors.TextBlack
$infoLabel.AutoSize = $true
$infoLabel.Location = New-Object System.Drawing.Point(10, 210)
$contentPanel.Controls.Add($infoLabel)

# Button panel at bottom
$buttonPanel = New-Object System.Windows.Forms.Panel
$buttonPanel.Size = New-Object System.Drawing.Size(526, 40)
$buttonPanel.Location = New-Object System.Drawing.Point(10, 462)
$buttonPanel.BackColor = $Colors.BgPanel
$outerPanel.Controls.Add($buttonPanel)

# 3D Line above buttons
$line3d = New-Object System.Windows.Forms.Panel
$line3d.Size = New-Object System.Drawing.Size(526, 2)
$line3d.Location = New-Object System.Drawing.Point(0, 0)
$line3d.BackColor = $Colors.BtnShadow
$buttonPanel.Controls.Add($line3d)

# Generate button
$genBtn = New-Object System.Windows.Forms.Button
$genBtn.Text = "&Generate"
$genBtn.Size = New-Object System.Drawing.Size(90, 25)
$genBtn.Location = New-Object System.Drawing.Point(100, 10)
$genBtn.FlatStyle = 'Flat'
$genBtn.BackColor = $Colors.BtnFace
$genBtn.Font = New-Object System.Drawing.Font('MS Sans Serif', 8)
$buttonPanel.Controls.Add($genBtn)

# Discord button
$discordBtn = New-Object System.Windows.Forms.Button
$discordBtn.Text = "&Discord"
$discordBtn.Size = New-Object System.Drawing.Size(90, 25)
$discordBtn.Location = New-Object System.Drawing.Point(200, 10)
$discordBtn.FlatStyle = 'Flat'
$discordBtn.BackColor = [System.Drawing.Color]::FromArgb(88, 101, 242)
$discordBtn.ForeColor = [System.Drawing.Color]::White
$discordBtn.Font = New-Object System.Drawing.Font('MS Sans Serif', 8, [System.Drawing.FontStyle]::Bold)
$buttonPanel.Controls.Add($discordBtn)

# Exit button
$exitBtn = New-Object System.Windows.Forms.Button
$exitBtn.Text = "E&xit"
$exitBtn.Size = New-Object System.Drawing.Size(90, 25)
$exitBtn.Location = New-Object System.Drawing.Point(300, 10)
$exitBtn.FlatStyle = 'Flat'
$exitBtn.BackColor = $Colors.BtnFace
$exitBtn.Font = New-Object System.Drawing.Font('MS Sans Serif', 8)
$buttonPanel.Controls.Add($exitBtn)

# Dialog
$dialog = New-Object System.Windows.Forms.FolderBrowserDialog
$dialog.Description = "Select WinRAR installation folder"

$browseBtn.Add_Click({
    if ($dialog.ShowDialog() -eq 'OK') {
        $pathBox.Text = $dialog.SelectedPath
    }
})

$exitBtn.Add_Click({ $colorTimer.Stop(); $form.Close() })

$discordBtn.Add_Click({
    Start-Process "https://discord.gg/bCQqKHGxja"
})

$genBtn.Add_Click({
    try {
        $dir = $pathBox.Text.Trim('"')
        
        if (-not $dir) { throw "Please select installation folder" }
        if (-not (Test-Path $dir)) { throw "Folder not found: $dir" }
        
        $winrarExe = Join-Path $dir 'WinRAR.exe'
        if (-not (Test-Path $winrarExe)) {
            $resp = [System.Windows.Forms.MessageBox]::Show(
                "WinRAR.exe not found.`n`nGenerate anyway?",
                "Confirm",
                [System.Windows.Forms.MessageBoxButtons]::YesNo,
                [System.Windows.Forms.MessageBoxIcon]::Question
            )
            if ($resp -ne [System.Windows.Forms.DialogResult]::Yes) { return }
        }
        
        $statusBox.Text = "Generating license key..."
        $statusBox.ForeColor = [System.Drawing.Color]::FromArgb(128, 0, 0)
        $form.Refresh()
        Start-Sleep -Milliseconds 500
        
        # Animate key generation
        $chars = "ABCDEF0123456789"
        for ($i = 0; $i -lt 10; $i++) {
            $randomKey = -join ((1..24) | ForEach-Object { 
                if ($_ % 5 -eq 0) { "-" } 
                else { $chars[(Get-Random -Maximum $chars.Length)] }
            })
            $keyBox.Text = $randomKey
            $keyBox.ForeColor = $Colors.NeonYellow
            $form.Refresh()
            Start-Sleep -Milliseconds 50
        }
        
        Write-KeyFile -Dir $dir
        
        $keyBox.Text = "UNLIMITED-CORPORATE-LICENSE-ACTIVATED"
        $keyBox.ForeColor = [System.Drawing.Color]::FromArgb(0, 128, 0)
        $statusBox.Text = "License generated successfully!"
        $statusBox.ForeColor = [System.Drawing.Color]::FromArgb(0, 128, 0)
        $genBtn.Enabled = $false
        $genBtn.Text = "Done!"
        
        [System.Windows.Forms.MessageBox]::Show(
            "License key generated successfully!`n`nSaved to: $dir\rarreg.key`n`nRestart WinRAR to activate.",
            "Success",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information
        ) | Out-Null
    }
    catch {
        $statusBox.Text = "Error: $($_.Exception.Message)"
        $statusBox.ForeColor = [System.Drawing.Color]::Red
        $keyBox.Text = "ERROR - GENERATION FAILED"
        $keyBox.ForeColor = [System.Drawing.Color]::Red
        
        [System.Windows.Forms.MessageBox]::Show(
            $_.Exception.Message,
            "Error",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        ) | Out-Null
    }
})



[void]$form.ShowDialog()
exit 0
