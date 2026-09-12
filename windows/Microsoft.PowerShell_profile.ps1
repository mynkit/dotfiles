Import-Module posh-git

# Mac/Linux風の行編集ショートカット (PSReadLine)
Set-PSReadLineKeyHandler -Chord Ctrl+u -Function BackwardDeleteLine   # カーソル位置から行頭まで削除
Set-PSReadLineKeyHandler -Chord Ctrl+k -Function ForwardDeleteLine    # カーソル位置から行末まで削除

# __git_ps1 風のシンプルなプロンプト: PS C:\path\to\repo (main *=) >
#   * = 未ステージの変更あり   + = ステージ済みの変更あり
#   = リモートと同期   > リモートより先行   < リモートより遅れ   <> 分岐
function prompt {
    Write-Host "PS $($executionContext.SessionState.Path.CurrentLocation)" -NoNewline
    $s = Get-GitStatus
    if ($s) {
        $marks = ''
        if ($s.HasWorking) { $marks += '*' }
        if ($s.HasIndex)   { $marks += '+' }
        if ($s.Upstream) {
            if ($s.AheadBy -gt 0 -and $s.BehindBy -gt 0) { $marks += ' <>' }
            elseif ($s.AheadBy -gt 0)  { $marks += ' >' }
            elseif ($s.BehindBy -gt 0) { $marks += ' <' }
            else { $marks += ' =' }
        }
        Write-Host " ($($s.Branch)$marks)" -NoNewline -ForegroundColor Green
    }
    return ' > '
}
