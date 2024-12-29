name: test
on: push
jobs:
  test:
    runs-on: ubuntu-22.04
    container: ryuichiueda/ubuntu22.04-ros2:latest
    steps:
      - uses: actions/checkout@v2
      - name: build and test
        run: |
          # ファイルを正しいディレクトリに配置
          rsync -av ./ /root/ros2_ws/src/mypkg/

          # 作業ディレクトリに移動
          cd /root/ros2_ws

          # ROS 2 環境を設定
          echo "ROS 2 環境を設定中..."
          if [ -f "/opt/ros/humble/setup.bash" ]; then
            source /opt/ros/humble/setup.bash
          elif [ -f "/opt/ros/foxy/setup.bash" ]; then
            source /opt/ros/foxy/setup.bash
          else
            echo "ROS 2 環境の設定に失敗しました"
            exit 1
          fi

          # ワークスペースの設定
          source install/local_setup.bash || { echo "ワークスペースの設定に失敗しました"; exit 1; }

          # テストスクリプトを実行
          bash -xv ./src/mypkg/test/test.bash /root

