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

# user-startup
create-shortcut "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\vcxsrv.lnk" `
    "C:\Program Files\VcXsrv\vcxsrv.exe" "-ac -terminate -lesspointer -multiwindow -wgl -primary"
# system-shortcut
create-shortcut "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\vcxsrv.lnk" `
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
  "vim.normalModeKeyBindings": [
    {
      "before": ["u"],
      "after": [],
      "commands": [
        { "command": "undo" }
      ]
    },
    {
      "before": ["<C-r>"],
      "after": [],
      "commands": [
        { "command": "redo" }
      ]
    }
  ],  
  "extensions.ignoreRecommendations": false,
  "editor.rulers": [
    100
  ],
  "editor.occurrencesHighlight": false,
  "editor.find.seedSearchStringFromSelection": false,
  "workbench.editor.enablePreviewFromQuickOpen": false,
  "workbench.editor.closeEmptyGroups": false,
  "workbench.colorTheme": "Monokai Dimmed",
  "terminal.integrated.tabs.enabled": false,
  "workbench.editor.untitled.hint": "hidden",
  "workbench.editor.enablePreview": false,
  "terminal.integrated.commandsToSkipShell": [
    "workbench.action.toggleSidebarVisibility"
  ]
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
    "key": "shift+alt+9",
    "command": "workbench.action.editorLayoutThreeRows"
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
  {
    "key": "ctrl+shift+tab",
    "command": "-workbench.action.quickOpenLeastRecentlyUsedEditorInGroup"
  },
  {
    "key": "ctrl+tab",
    "command": "-workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup"
  },
  {
    "key": "ctrl+shift+tab",
    "command": "workbench.action.previousEditor"
  },
  {
    "key": "ctrl+tab",
    "command": "workbench.action.nextEditor"
  },
  {
    "key": "ctrl+e",
    "command": "-workbench.action.quickOpen"
  },
  {
    "key": "ctrl+shift+j",
    "command": "-workbench.action.search.toggleQueryDetails",
    "when": "inSearchEditor || searchViewletFocus"
  },
  {
    "key": "ctrl+shift+j",
    "command": "workbench.action.toggleMaximizedPanel"
  },
  {
    "key": "ctrl+k",
    "command": "workbench.action.terminal.clear",
    "when": "terminalFocus"
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
