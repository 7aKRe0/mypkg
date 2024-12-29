#!/bin/bash

# 作業ディレクトリの設定
dir=~
[ "$1" != "" ] && dir="$1"
cd $dir/ros2_ws || { echo "作業ディレクトリに移動できません"; exit 1; }

# ビルドの実行
colcon build || { echo "ビルド失敗"; exit 1; }

# 環境を再設定
source $dir/.bashrc

# トーカーを実行してログを保存
echo "トーカーを実行してログを保存中..."
timeout 10 ros2 run mypkg talker > /tmp/mypkg.log

# 現在時刻を取得
current_time=$(date +"%H:%M")
echo "現在時刻: $current_time"

# ログの確認
echo "ログを確認中..."

# 1. 現在時刻に一致する行を抽出
log_line=$(grep "$current_time" /tmp/mypkg.log)

if [ -z "$log_line" ]; then
    echo "テスト失敗: 現在時刻の情報がログに見つかりません"
    exit 1
fi

# 2. 予定の有無を判定
if echo "$log_line" | grep -q "予定なし"; then
    echo "テスト成功: 現在時刻に予定がないことが正しく表示されました"
    exit 0
elif echo "$log_line" | grep -q "イベント"; then
    echo "テスト成功: 現在時刻のイベントが正しく表示されました"
    exit 0
else
    echo "テスト失敗: 現在時刻のログに必要な情報が不足しています"
    exit 1
fi

