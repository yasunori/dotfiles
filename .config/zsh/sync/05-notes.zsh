###################
# notes関連
# notes-cli を導入した
# cf. https://github.com/rhysd/notes-cli
#
# 必要なもの
# - fzf
# - ccat
# - bat
# - rg
###################

# 最後スラッシュをつけないこと。notesmoveで使っている
export NOTES_CLI_HOME=$HOME/notes
export NOTES_CLI_TEMPLATE=$HOME/notes/template.md

# notes-new category filename
# ファイル名に日付が無ければ補完する
# あればedit、無ければnew
function notesnew() {
    local f
    local category
    local filename
    local cnt
    local filefullpath
    if [ -n "$1" ]; then
        category=$1
    else
        echo -n category?:
        read category
    fi

    if [ -n "$2" ]; then
        f=$2
    else
        echo -n filename?:
        read f
    fi

    # filenameに日付を補完する
    if [[ $f =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}.{0,} ]]; then
        filename=$f
    else
        filename=`notesdate`-$f
    fi

    filename=`echo ${filename// /-}`  # スペースは-に変換する
    filefullpath=`notesfullpath $category $filename`
    if [ ! -e "$filefullpath" ]; then
        # new
        # diary は notesの力を借りようかな
        # ほかはコピーで作ったほうがはやい
        if [[ $category =~ ^diary$ ]]; then
            notes new $category $filename
        else
            notesnewbyfullpath $filefullpath
        fi
    fi

    notesopen $filefullpath
}

# noteを開くとき、notes directoryに遷移すると補完などに便利なのでそうする
# vimのterminal内のときはやらない
function notesopen() {
    local filefullpath
    if [ -n "$1" ]; then
        filefullpath=$1
        if [ -z "$VIMRUNTIME" ]; then  # vimから呼ばれていないときはcdする
            (cd $NOTES_CLI_HOME && $EDITOR "$filefullpath")
        else
            $EDITOR "$filefullpath"
        fi
    fi
}

# ファイル用のdate表示
function notesdate() {
    local d
    export TZ="Asia/Tokyo"
    d=$(date "+%Y-%m-%d")
    unset TZ
    echo $d
}

# ヘッダ用のdate iso表示
function notesdateiso() {
    local d
    export TZ="Asia/Tokyo"
    d=$(date -I"seconds")
    unset TZ
    echo $d
}

# categoryとfilenameから絶対パスを取得
function notesfullpath() {
    local category
    local filename
    if [ -n "$1" ] && [ -n "$2" ]; then
        category=$1
        if [[ $2 =~ .md ]]; then
            filename=$2
        else
            filename=$2.md
        fi
        echo $NOTES_CLI_HOME/$category/$filename
    fi
}

# 絶対パスから現在のカテゴリを取得
function notescategory() {
    if [ -n "$1" ]; then
        echo $1 | sed -e "s@`echo $NOTES_CLI_HOME`/@@g" | sed -e "s@/`echo $(basename $1)`@@g"
    fi
}

# notesnewのエイリアス
# よく間違えるので作った
function notesadd() {
    notesnew $1 $2 $3
}

# notesをgrepしてfzfして開く
# 該当行を表示したいために rg に -l をつけない。代わりにcatしてawkしてeditorに渡す
function notesgrep() {
    local -A opthash
    local opts
    local word
    zparseopts -D -A opthash -- c: t:
    opts=""
    if [[ -n "${opthash[(i)-c]}" ]]; then
      opts=" $opts -c ${opthash[-c]}"
    fi
    if [[ -n "${opthash[(i)-t]}" ]]; then
      opts=" $opts -t ${opthash[-t]}"
    fi
    word=$@

    local list
    local file
    local cnt
    if [ -n "$word" ]; then
        list=$(notes ls `echo ${opts}`)
        if [ -n "$list" ]; then
            # 1行だったらそのまま開く
            # TODO 1行表示がおかしいため
            cnt=$(notes ls `echo ${opts}` | xargs rg -l -i "$word" | wc -l)
            if [ $cnt = 1 ]; then
                file=$(notes ls `echo ${opts}` | xargs rg -l -i "$word")
                # $EDITOR "$file"
                notesopen $file
            else
                file=$(notes ls `echo ${opts}` | xargs rg -i "$word" | rg -v -e 'remove' | ccat | fzf --height=100% | awk -F: '{print $1}')
                if [ -n "$file" ]; then
                    notesopen $file
                fi
            fi
        fi
    fi
}

# notes名をfindしてfzfして開く
function noteslist() {
    local -A opthash
    local opts
    local word
    zparseopts -D -A opthash -- c: t:
    opts=""
    if [[ -n "${opthash[(i)-c]}" ]]; then
      opts=" $opts -c ${opthash[-c]}"
    fi
    if [[ -n "${opthash[(i)-t]}" ]]; then
      opts=" $opts -t ${opthash[-t]}"
    fi
    word=$@

    local list
    local files
    local file
    if [ -z "$word" ]; then
        word="md"  # 必ずあるword=>全部出す
    fi
    list=$(notes ls `echo ${opts}`)
    if [ -n "$list" ]; then
        files=$(notes ls `echo ${opts}` | rg -i $word)
        if [ -n "$files" ]; then
            file=$(notes ls `echo ${opts}` | rg -i $word | fzf --height 100% --preview "bat --color=always --style=grid --line-range :100 {}")
            if [ -n "$file" ]; then
                notesopen $file
            fi
        fi
    fi
}


function notesmove() {
    local new_category
    local filefullpath
    if [ -n "$1" ]; then
        new_category=$1
        echo "new_category?: $new_category"
    else
        echo -n new category?:
        read new_category
    fi

    filefullpath=$(notes ls | fzf)
    notesmoveone $new_category $filefullpath
}

# 1つのファイルについてカテゴリを移動させる
# new_category filefullpath_from
function notesmoveone() {
    local filefullpath_from
    local filefullpath_to
    local filename
    local category_from
    local category_to
    local category_key_from
    local category_key_to
    if [ -n "$1" ] && [ -n "$2" ]; then
        filefullpath_from=$2
        filename=`basename $filefullpath_from`
        category_from=`notescategory $filefullpath_from`
        category_to=$1
        filefullpath_to=`notesfullpath $category_to $filename`

        mv $filefullpath_from $filefullpath_to

        if [[ -e $filefullpath_to ]]; then
            category_key_fron="Category: $category_from"
            category_key_to="Category: $category_to"

            sed -i "s@`echo $category_key_fron`@`echo $category_key_to`@g" $filefullpath_to
        fi
    fi
}

# fullpathからnote作成
# notes 機能を使わずにがんばる
function notesnewbyfullpath() {
    local filefullpath
    if [ -n "$1" ]; then
        filefullpath=$1
        cp $NOTES_CLI_TEMPLATE $filefullpath
        notesrestructheader $filefullpath
    fi
}

# ファイルパスからheaderを再定義する
# ヘッダがない場合は作成する
function notesrestructheader() {
    local filefullpath
    local filename
    local category
    local title
    local category_key_from
    local category_key_to
    local created_key_from
    local created_key_to
    local current_created
    local header="default\n=====================\n<!--\n- Category: default\n- Tags:\n- Created: default\n-->\n"
    if [ -n "$1" ]; then
        filefullpath=$1

        # ファイルパスから正しいカテゴリやタイトルを切り出す
        filename=`basename $filefullpath`
        category=`notescategory $filefullpath`
        date=`echo $filename | sed -r 's/.*([0-9-]{10})\-.*/\1/g'`
        title=`echo $filename | sed -r 's/(^.*)\.md$/\1/g'`

        if [[ -e $filefullpath ]]; then
            # headerの確認
            current_2p=`sed -n 2P $filefullpath`
            if [ `echo $current_2p | grep '====='` ] ; then  # 2行目に=====があるかどうかで判断 TODO
                # do nothing
            else
                # headerのテンプレートを挿入
                sed -i -e "1i $header" $filefullpath
            fi

            # 1行目はタイトル
            sed -i -e "1d" $filefullpath
            sed -i -e "1i `echo $title`" $filefullpath

            # カテゴリの置換
            category_key_from="Category: .*$"
            category_key_to="Category: $category"
            sed -i "s@`echo $category_key_from`@`echo $category_key_to`@g" $filefullpath

            # Createdの置換
            # 1. filenameから取得したdateと、headerのdateが同じ
            #   -> おそらく正しいのでそのまま使う
            #
            # 2. filenameから取得したdateが本日の場合
            #   -> 現在時刻を入れてしまおう
            #
            # 3. filenameから取得したdateが本日ではない場合
            #   -> なんかおかしいが、headerを書き換えたいのだろう。dateT00:00:00

            # 現在のcreatedを取得
            current_created=`sed -n 6P $filefullpath | sed -r 's/\- Created: (.*)$/\1/g'`
            current_created_date=`sed -n 6P $filefullpath | sed -r 's/.*([0-9]{4}\-[0-9]{2}\-[0-9]{2}).*/\1/g'`
            today_date=`notesdate`
            if [ $current_created_date = $date ]; then
                # do nothing
            else
                if [ $date = $today_date ]; then
                    created_key_to="Created: `notesdateiso`"  # 今を入れる

                else
                    created_key_to="Created: `echo $date`T00:00:00+09:00"
                fi
                created_key_from="Created: .*$"
                sed -i "s@`echo $created_key_from`@`echo $created_key_to`@g" $filefullpath
            fi
        fi
    fi
}


# 日報
function notesdiary() {
    notesnew diary diary
}

# メモ
function notesmemo() {
    local file 
    if [ -n "$1" ]; then
        file=$1
    else
        echo -n filename?:
        read file
    fi
    notesnew memo $file
}

# チェックのついていないチェックボックスを検索
function notestodo() {
    notesgrep "\[\s\]"
}

# チェックのついたチェックボックスを検索
function notesdone() {
    notesgrep "\[x\]"
}

# なんとなく合わせる
function notessave() {
    notes save
}

# pull
function notespull() {
    (cd $NOTES_CLI_HOME && git pull)
}

# n で呼び出す
function n() {
    local cmd
    if [ -n "$1" ]; then
        cmd=$1
        case "$cmd" in
            "list" ) noteslist ${@:2};;
            "grep" ) notesgrep ${@:2};;
            "add" ) notesnew $2 $3 $4;;
            "new" ) notesnew $2 $3 $4;;
            "memo" ) notesmemo;;
            "diary" ) notesdiary;;
            "todo" ) notestodo;;
            "done" ) notesdone;;
            "save" ) notessave;;
            "pull" ) notespull;;
        esac
    else
        # 基本はnoteslist
        noteslist
    fi
}
