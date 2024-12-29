# mypkg

# スケジュール管理ノード
時間割や予定を管理するノード。現在の時刻に応じた予定をトピックで通知。

## トピックの名前とメッセージの型
   名前: /countup

   型：  16ビット符号付き整数


## 使い方
```
➀  talkerとlistenerを使う場合

パッケージをインストールした後端末を2つ用意する

片方の端末に

$ ros2 run mypkg talker

と入力し、そのあともう片方の端末に

$ ros2 run mypkg listener

と入力するとtalkerでカウントされている数字がlistenerを打った方の端末に表示される

(表示例)

[INFO] [1672591352.264734808] [listener]: Listen: 8
[INFO] [1672591352.752466694] [listener]: Listen: 9
[INFO] [1672591353.253440655] [listener]: Listen: 10
[INFO] [1672591353.753527085] [listener]: Listen: 11
[INFO] [1672591354.253675383] [listener]: Listen: 12


➁　talk_listen.launch.pyを使う場合

パッケージをインストールした後

$ ros2 launch mypkg talk_listen.launch.py

と入力するとカウントされている数字が表示される

(表示例)

[INFO] [launch]: All log files can be found below /home/soma/.ros/log/2023-01-02-04-26-14-895653-LAPTOP-HQDBHS8P-4932
[INFO] [launch]: Default logging verbosity is set to INFO
[INFO] [talker-1]: process started with pid [4934]
[INFO] [listener-2]: process started with pid [4936]
[listener-2] [INFO] [1672601175.711184893] [listener]: Listen: 0
[listener-2] [INFO] [1672601176.196026819] [listener]: Listen: 1
[listener-2] [INFO] [1672601176.697546007] [listener]: Listen: 2
[listener-2] [INFO] [1672601177.197213510] [listener]: Listen: 3
[listener-2] [INFO] [1672601177.697309567] [listener]: Listen: 4
[listener-2] [INFO] [1672601178.196519683] [listener]: Listen: 5

```

## ROSのバージョン
   ROS2

## 必要なソフトウェア
   - Python
   - ROS2
     
## テスト環境
- Ubuntu 22.04 LTS
- python
  - テスト済みバージョン:3.7~3.10
  
# 著作権・ライセンス
- このソフトウェアパッケージは，3条項BSDライセンスの下，再頒布および使用が許可されます．
- このパッケージのコードの一部は，下記のスライド（CC-BY-SA 4.0 by Ryuichi Ueda）のものを，本人の許可を得て自身の著作としたものです．
    - https://github.com/ryuichiueda/slides_marp/tree/master/robosys2024
 
© 2024 Ryosuke Naka
