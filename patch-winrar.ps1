$ErrorActionPreference = 'Stop'

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

$DefaultDir = 'C:\Program Files\WinRAR'
$KeyName    = 'rarreg.key'

function Require-Admin {
    $id = [Security.Principal.WindowsIdentity]::GetCurrent()
    $pr = New-Object Security.Principal.WindowsPrincipal($id)
    if (-not $pr.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
        [System.Windows.Forms.MessageBox]::Show(
            "Run this patcher as Administrator.",
            "WinRAR Patcher",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Warning
        ) | Out-Null
        exit 1
    }
}

function Write-KeyFile {
    param([string]$Dir)
    $dest = Join-Path $Dir $KeyName
    if (-not (Test-Path $Dir)) {
        New-Item -Path $Dir -ItemType Directory -Force | Out-Null
    }
    Set-Content -Path $dest -Value $KeyLines -Encoding ASCII -Force
}

# Load WinForms
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Require-Admin
[System.Windows.Forms.Application]::EnableVisualStyles()

# Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "WinRAR Patcher"
$form.Size = New-Object System.Drawing.Size(540,210)
$form.StartPosition = 'CenterScreen'
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false
$form.MinimizeBox = $false

$label = New-Object System.Windows.Forms.Label
$label.Text = "WinRAR folder:"
$label.AutoSize = $true
$label.Location = New-Object System.Drawing.Point(12,15)
$form.Controls.Add($label)

$textbox = New-Object System.Windows.Forms.TextBox
$textbox.Size = New-Object System.Drawing.Size(360,20)
$textbox.Location = New-Object System.Drawing.Point(110,12)
$textbox.Text = $DefaultDir
$form.Controls.Add($textbox)

$browse = New-Object System.Windows.Forms.Button
$browse.Text = "Browse..."
$browse.Size = New-Object System.Drawing.Size(90,24)
$browse.Location = New-Object System.Drawing.Point(380,10)
$form.Controls.Add($browse)

$status = New-Object System.Windows.Forms.Label
$status.AutoSize = $true
$status.Location = New-Object System.Drawing.Point(12,120)
$status.Text = ""
$form.Controls.Add($status)

$patchBtn = New-Object System.Windows.Forms.Button
$patchBtn.Text = "Patch"
$patchBtn.Size = New-Object System.Drawing.Size(110,34)
$patchBtn.Location = New-Object System.Drawing.Point(150,60)
$form.Controls.Add($patchBtn)

$closeBtn = New-Object System.Windows.Forms.Button
$closeBtn.Text = "Close"
$closeBtn.Size = New-Object System.Drawing.Size(110,34)
$closeBtn.Location = New-Object System.Drawing.Point(280,60)
$form.Controls.Add($closeBtn)

$dialog = New-Object System.Windows.Forms.FolderBrowserDialog

$browse.Add_Click({
    if ($dialog.ShowDialog() -eq 'OK') {
        $textbox.Text = $dialog.SelectedPath
    }
})

$closeBtn.Add_Click({ $form.Close() })

$patchBtn.Add_Click({
    try {
        $dir = $textbox.Text.Trim('"')
        if (-not $dir) { throw "Folder is empty." }
        if (-not (Test-Path $dir)) { throw "Folder not found: $dir" }

        $winrarExe = Join-Path $dir 'WinRAR.exe'
        if (-not (Test-Path $winrarExe)) {
            $resp = [System.Windows.Forms.MessageBox]::Show(
                "WinRAR.exe not found in that folder. Patch anyway?",
                "Confirm",
                [System.Windows.Forms.MessageBoxButtons]::YesNo,
                [System.Windows.Forms.MessageBoxIcon]::Question
            )
            if ($resp -ne [Windows.Forms.DialogResult]::Yes) { return }
        }

        Write-KeyFile -Dir $dir
        $status.ForeColor = [System.Drawing.Color]::Green
        $status.Text = "Key placed in $dir. You can close the patcher."
        [System.Windows.Forms.MessageBox]::Show(
            "Key placed. Restart WinRAR if it was open.",
            "Done",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information
        ) | Out-Null
    }
    catch {
        $status.ForeColor = [System.Drawing.Color]::Red
        $status.Text = $_.Exception.Message
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
