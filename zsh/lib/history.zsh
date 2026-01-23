# ------------------------------------------------------------------------------
# HISTORY
# ------------------------------------------------------------------------------

HISTFILE=$HOME/.zsh_history     # 履歴を保存するファイル
HISTSIZE=100000                 # メモリ上に保存する履歴のサイズ
SAVEHIST=1000000                # 上述のファイルに保存する履歴のサイズ

# share .zshhistory
setopt inc_append_history       # 実行時に履歴をファイルにに追加していく
setopt share_history            # 履歴を他のシェルとリアルタイム共有する
setopt hist_verify              # 履歴を呼び出す時に実行前の内容を一度表示する


setopt hist_ignore_all_dups     # ヒストリーに重複を表示しない
setopt hist_save_no_dups        # 重複するコマンドが保存されるとき、古い方を削除する
setopt extended_history         # コマンドのタイムスタンプをHISTFILEに記録する
setopt hist_expire_dups_first   # HISTFILEのサイズがHISTSIZEを超える場合は、最初に重複を削除する

# ignore
setopt extended_glob
function zshaddhistory() {
    local line=${1%%$'\n'}
    if [[ "$line" =~ "^(ls|pwd|tm|exit|git add|git res|git ress|git ame|git st|git push -f)" ]]; then
        return 1 # 履歴に保存しない
    fi
    return 0 # 履歴に保存する
}