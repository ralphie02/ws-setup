function create-shortcut {
  param ( [string]$src, [string]$dest, [string]$src_args )
    $wscript_shell = New-Object -comObject WScript.Shell
    $shortcut = $wscript_shell.CreateShortcut($src)
    $shortcut.TargetPath = $dest
    $shortcut.Arguments = $src_args
    $shortcut.Save()
}
#------------------------ KEEPASS -----------------------#

winget install --id DominikReichl.KeePass

#------------------------ VCXSRV ------------------------#

winget install vcxsrv

create-shortcut "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\vcxsrv.lnk" `
    "C:\Program Files\VcXsrv\vcxsrv.exe" "-ac -terminate -lesspointer -multiwindow -wgl -primary"
create-shortcut "C:\Users\Public\Desktop\vcxsrv.lnk" `
    "C:\Program Files\VcXsrv\vcxsrv.exe" "-ac -terminate -lesspointer -multiwindow -wgl -primary"

#------------------------ VSCODE ------------------------#

winget install vscode

## Install vscode extensions
@("ms-vscode-remote.remote-wsl", "vscodevim.vim", "ms-vscode-remote.vscode-remote-extensionpack") `
  | foreach { code --install-extension $_ }

## Set variables
$settings = @'
{
  "remote.SSH.showLoginTerminal": true,
  "git.ignoreLegacyWarning": true,
  "terminal.integrated.shell.linux": "/bin/bash",
  "terminal.integrated.rightClickBehavior": "default",
  "files.trimTrailingWhitespace": true,
  "files.insertFinalNewline": true,
  "editor.tabSize": 2,
  "editor.insertSpaces": true,
  "vim.useCtrlKeys": false,
  "vim.handleKeys": {
    "<C-c>": false,
    "<C-d>": false,
    "<C-u>": false,
    "<C-v>": false,
  },
  "extensions.ignoreRecommendations": false,
  "editor.rulers": [
    100
  ],
}
'@.Trim()
$keybindings = @'
// Place your key bindings in this file to override the defaultsauto[]
[
  {
    "key": "shift+alt+1",
    "command": "-workbench.action.moveEditorToFirstGroup"
  },
  {
    "key": "shift+alt+1",
    "command": "workbench.action.editorLayoutSingle"
  },
  {
    "key": "shift+alt+2",
    "command": "workbench.action.editorLayoutTwoColumns"
  },
  {
    "key": "shift+alt+3",
    "command": "workbench.action.editorLayoutThreeColumns"
  },
  {
    "key": "ctrl+alt+up",
    "command": "-extension.vim_cmd+alt+up",
    "when": "editorTextFocus && vim.active && !inDebugRepl"
  },
  {
    "key": "ctrl+alt+down",
    "command": "-extension.vim_cmd+alt+down",
    "when": "editorTextFocus && vim.active && !inDebugRepl"
  },
  {
    "key": "delete",
    "command": "-extension.vim_delete",
    "when": "editorTextFocus && vim.active && !inDebugRepl"
  },
  {
    "key": "shift+alt+8",
    "command": "workbench.action.editorLayoutTwoRows"
  },
  {
    "key": "ctrl+shift+-",
    "command": "-workbench.action.zoomOut"
  },
  {
    "key": "ctrl+shift+-",
    "command": "workbench.action.splitEditorOrthogonal"
  },
  {
    "key": "ctrl+k ctrl+\\",
    "command": "-workbench.action.splitEditorOrthogonal"
  },
  {
    "key": "ctrl+\\",
    "command": "editor.action.jumpToBracket",
    "when": "editorTextFocus"
  },
  {
    "key": "ctrl+shift+\\",
    "command": "-editor.action.jumpToBracket",
    "when": "editorTextFocus"
  },
  {
    "key": "ctrl+shift+\\",
    "command": "workbench.action.splitEditor"
  },
  {
    "key": "ctrl+\\",
    "command": "-workbench.action.splitEditor"
  },
]
'@.Trim()
$preferences = @{ settings = $settings; keybindings = $keybindings }
$preferences_path = "$env:APPDATA\Code\User"

## Configure settings.json & keybindings.json
$preferences.GetEnumerator() | foreach {
    $file_exists? = [System.IO.File]::Exists("$preferences_path\$($_.key).json")
    if($file_exists?){
        $content = (gc "$preferences_path\$($_.key).json" -Raw).Trim()
        if(Compare-Object -ReferenceObject $content -DifferenceObject $_.value){
            echo "before:" $content "after:" $_.value
            Copy-Item -Path "$preferences_path\$($_.key).json" `
                -Destination "$preferences_path\$($_.key).json.$(Get-Date -Format yyyyMMddTHHmmss)"
            Set-Content "$preferences_path\$($_.key).json" $_.value
        } else {
            echo "no change"
        }
    }
    else{
        Set-Content "$preferences_path\$($_.key).json" $_.value
    }
}
