#!/bin/bash

# 作業ディレクトリの設定
dir=~  # デフォルトはホームディレクトリ
[ "$1" != "" ] && dir="$1"
cd $dir/ros2_ws || { echo "作業ディレクトリに移動できません"; exit 1; }

# 環境設定
echo "ROS 2 環境を設定中..."
source /opt/ros/foxy/setup.bash || { echo "ROS 2 環境の設定に失敗しました"; exit 1; }
source install/local_setup.bash || { echo "ワークスペースの設定に失敗しました"; exit 1; }

# 環境変数の確認
echo "PATH: $PATH"
echo "COLCON_PREFIX_PATH: $COLCON_PREFIX_PATH"

# ビルドの実行
colcon build || { echo "ビルド失敗"; exit 1; }

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

