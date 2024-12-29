#!/bin/bash

# 作業ディレクトリの設定
dir=~
[ "$1" != "" ] && dir="$1"
cd $dir/ros2_ws || { echo "作業ディレクトリに移動できません"; exit 1; }

# 環境設定
source /opt/ros/foxy/setup.bash
source install/local_setup.bash

# ビルドの実行
colcon build || { echo "ビルド失敗"; exit 1; }

# ROS 2 コマンド確認
echo "ROS 2 コマンドの場所: $(which ros2)"

# トーカーを実行してログを保存
echo "トーカーを実行してログを保存中..."
timeout 30 ros2 run mypkg talker > /tmp/mypkg.log 2>&1

# 現在時刻を取得
current_time=$(date +"%H:%M")
echo "現在時刻: $current_time"

# ログの内容を表示
echo "ログ内容:"
cat /tmp/mypkg.log || { echo "ログが空です"; exit 1; }

# 現在時刻に一致する行を抽出（前後1分も含む）
log_line=$(grep -E "現在時刻: ($current_time|$(date -d '-1 minute' +%H:%M)|$(date -d '+1 minute' +%H:%M))" /tmp/mypkg.log)

if [ -z "$log_line" ]; then
    echo "テスト失敗: 現在時刻の情報がログに見つかりません"
    exit 1
fi

# 出力に「予定なし」または「イベント」が含まれているか確認
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

