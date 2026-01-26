param(
    [string]$InstallPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Configuration
$AppTitle   = 'WinRAR Key Installer'
$AppTagline = 'RETRO KEYGEN EDITION'
$DefaultDir = Join-Path $env:ProgramFiles 'WinRAR'
$KeyName    = 'rarreg.key'

# Embedded key contents
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

if (-not $InstallPath) {
    $InstallPath = $DefaultDir
}

# Load WinForms
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$ColorBack   = [System.Drawing.Color]::FromArgb(12, 12, 12)
$ColorFore   = [System.Drawing.Color]::FromArgb(0, 220, 80)
$ColorDim    = [System.Drawing.Color]::FromArgb(0, 150, 70)
$ColorAccent = [System.Drawing.Color]::FromArgb(80, 255, 160)
$ColorError  = [System.Drawing.Color]::FromArgb(255, 80, 80)
$ColorInput  = [System.Drawing.Color]::FromArgb(20, 20, 20)

$FontTitle = New-Object System.Drawing.Font('Lucida Console', 12, [System.Drawing.FontStyle]::Bold)
$FontMono  = New-Object System.Drawing.Font('Consolas', 9, [System.Drawing.FontStyle]::Regular)
$FontSmall = New-Object System.Drawing.Font('Consolas', 8, [System.Drawing.FontStyle]::Regular)

$script:LogBox = $null

function Show-Dialog {
    param(
        [string]$Text,
        [string]$Title,
        [System.Windows.Forms.MessageBoxButtons]$Buttons = [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]$Icon = [System.Windows.Forms.MessageBoxIcon]::Information
    )
    return [System.Windows.Forms.MessageBox]::Show($Text, $Title, $Buttons, $Icon)
}

function Require-Admin {
    $id = [Security.Principal.WindowsIdentity]::GetCurrent()
    $pr = New-Object Security.Principal.WindowsPrincipal($id)
    if (-not $pr.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
        Show-Dialog -Text 'Run this patcher as Administrator.' -Title $AppTitle -Icon Warning | Out-Null
        exit 1
    }
}

function Write-KeyFile {
    param([string]$Dir)
    $dest = Join-Path $Dir $KeyName
    if (-not (Test-Path -Path $Dir -PathType Container)) {
        New-Item -Path $Dir -ItemType Directory -Force | Out-Null
    }
    Set-Content -Path $dest -Value $KeyLines -Encoding ASCII -Force
}

function Write-Log {
    param([string]$Text)
    if (-not $script:LogBox) { return }
    $stamp = (Get-Date).ToString('HH:mm:ss')
    $script:LogBox.AppendText("[$stamp] $Text`r`n")
}

function Set-ButtonStyle {
    param([System.Windows.Forms.Button]$Button)
    $Button.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $Button.BackColor = $ColorBack
    $Button.ForeColor = $ColorFore
    $Button.FlatAppearance.BorderColor = $ColorDim
    $Button.FlatAppearance.BorderSize = 1
}

Require-Admin
[System.Windows.Forms.Application]::EnableVisualStyles()

# Form
$form = New-Object System.Windows.Forms.Form
$form.Text = $AppTitle
$form.Size = New-Object System.Drawing.Size(560, 320)
$form.StartPosition = 'CenterScreen'
$form.FormBorderStyle = 'FixedSingle'
$form.ShowIcon = $false
$form.MaximizeBox = $false
$form.MinimizeBox = $false
$form.BackColor = $ColorBack
$form.ForeColor = $ColorFore
$form.Font = $FontMono

$title = New-Object System.Windows.Forms.Label
$title.Text = 'WINRAR KEYGEN'
$title.AutoSize = $true
$title.Location = New-Object System.Drawing.Point(12, 8)
$title.Font = $FontTitle
$title.ForeColor = $ColorAccent
$form.Controls.Add($title)

$tagline = New-Object System.Windows.Forms.Label
$tagline.Text = $AppTagline
$tagline.AutoSize = $true
$tagline.Location = New-Object System.Drawing.Point(14, 32)
$tagline.Font = $FontSmall
$tagline.ForeColor = $ColorDim
$form.Controls.Add($tagline)

$separator = New-Object System.Windows.Forms.Label
$separator.Text = '--------------------------------------------------------------'
$separator.AutoSize = $true
$separator.Location = New-Object System.Drawing.Point(12, 50)
$separator.Font = $FontSmall
$separator.ForeColor = $ColorDim
$form.Controls.Add($separator)

$label = New-Object System.Windows.Forms.Label
$label.Text = 'Target folder'
$label.AutoSize = $true
$label.Location = New-Object System.Drawing.Point(12, 72)
$form.Controls.Add($label)

$textbox = New-Object System.Windows.Forms.TextBox
$textbox.Size = New-Object System.Drawing.Size(400, 20)
$textbox.Location = New-Object System.Drawing.Point(12, 90)
$textbox.Text = $InstallPath
$textbox.BackColor = $ColorInput
$textbox.ForeColor = $ColorAccent
$textbox.BorderStyle = 'FixedSingle'
$form.Controls.Add($textbox)

$browse = New-Object System.Windows.Forms.Button
$browse.Text = 'Browse'
$browse.Size = New-Object System.Drawing.Size(100, 24)
$browse.Location = New-Object System.Drawing.Point(424, 88)
Set-ButtonStyle -Button $browse
$form.Controls.Add($browse)

$patchBtn = New-Object System.Windows.Forms.Button
$patchBtn.Text = 'INSTALL KEY'
$patchBtn.Size = New-Object System.Drawing.Size(120, 34)
$patchBtn.Location = New-Object System.Drawing.Point(155, 124)
Set-ButtonStyle -Button $patchBtn
$form.Controls.Add($patchBtn)

$closeBtn = New-Object System.Windows.Forms.Button
$closeBtn.Text = 'EXIT'
$closeBtn.Size = New-Object System.Drawing.Size(120, 34)
$closeBtn.Location = New-Object System.Drawing.Point(285, 124)
Set-ButtonStyle -Button $closeBtn
$form.Controls.Add($closeBtn)

$logLabel = New-Object System.Windows.Forms.Label
$logLabel.Text = 'STATUS LOG'
$logLabel.AutoSize = $true
$logLabel.Location = New-Object System.Drawing.Point(12, 170)
$logLabel.Font = $FontSmall
$logLabel.ForeColor = $ColorDim
$form.Controls.Add($logLabel)

$logBox = New-Object System.Windows.Forms.TextBox
$logBox.Multiline = $true
$logBox.ReadOnly = $true
$logBox.ScrollBars = 'Vertical'
$logBox.Size = New-Object System.Drawing.Size(512, 90)
$logBox.Location = New-Object System.Drawing.Point(12, 188)
$logBox.BackColor = $ColorInput
$logBox.ForeColor = $ColorFore
$logBox.BorderStyle = 'FixedSingle'
$form.Controls.Add($logBox)
$script:LogBox = $logBox

$dialog = New-Object System.Windows.Forms.FolderBrowserDialog
$dialog.Description = 'Select the WinRAR installation folder'
$dialog.SelectedPath = $InstallPath

$browse.Add_Click({
    if ($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $textbox.Text = $dialog.SelectedPath
    }
})

$closeBtn.Add_Click({ $form.Close() })

$patchBtn.Add_Click({
    try {
        $dir = $textbox.Text.Trim().Trim('"')
        if (-not $dir) { throw 'Folder is empty.' }
        if (-not (Test-Path -Path $dir -PathType Container)) { throw "Folder not found: $dir" }

        $winrarExe = Join-Path $dir 'WinRAR.exe'
        if (-not (Test-Path $winrarExe)) {
            $resp = Show-Dialog -Text 'WinRAR.exe not found in that folder. Install key anyway?' -Title 'Confirm' -Buttons YesNo -Icon Question
            if ($resp -ne [System.Windows.Forms.DialogResult]::Yes) {
                Write-Log 'Install cancelled by user.'
                return
            }
        }

        Write-Log "Installing key to $dir"
        Write-KeyFile -Dir $dir
        Write-Log "Key placed: $(Join-Path $dir $KeyName)"

        Show-Dialog -Text 'Key placed. Restart WinRAR if it was open.' -Title 'Done' -Icon Information | Out-Null
    }
    catch {
        $msg = $_.Exception.Message
        Write-Log "ERROR: $msg"
        Show-Dialog -Text $msg -Title 'Error' -Icon Error | Out-Null
    }
})

$form.AcceptButton = $patchBtn
$form.CancelButton = $closeBtn
$form.Add_Shown({ Write-Log 'Ready. Select WinRAR folder and install key.' })

[void]$form.ShowDialog()
exit 0
