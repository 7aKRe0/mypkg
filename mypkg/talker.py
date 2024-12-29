import rclpy
from rclpy.node import Node
from std_msgs.msg import String
from datetime import datetime

class ScheduleTalker(Node):
    def __init__(self):
        super().__init__('schedule_talker')
        self.publisher_ = self.create_publisher(String, 'schedule_topic', 10)
        self.timer = self.create_timer(10.0, self.timer_callback)  # 10秒ごとにチェック
        self.schedules = [
            {"time": "15:00", "event": "お菓子の時間"},
            {"time": "18:00", "event": "夕食の準備"},
            {"time": "21:07", "event": "お風呂の時間"}
        ]

    def timer_callback(self):
        now = datetime.now().strftime("%H:%M")
        self.get_logger().info(f"現在時刻: {now} - タイマー実行中")

        current_event = None
        next_event = None

        for schedule in self.schedules:
            if schedule["time"] == now:
                current_event = schedule
                break

        for schedule in self.schedules:
            if schedule["time"] > now:
                next_event = schedule
                break

        if current_event:
            msg_data = f"現在時刻: {now}, イベント: {current_event['event']}"
        else:
            if next_event:
                msg_data = f"現在時刻: {now}, 現在予定なし。次の予定: {next_event['time']} - {next_event['event']}"
            else:
                msg_data = f"現在時刻: {now}, 現在予定なし。次の予定はありません。"

        self.get_logger().info(f"パブリッシュ予定メッセージ: {msg_data}")
        msg = String()
        msg.data = msg_data
        self.publisher_.publish(msg)

def main(args=None):
    rclpy.init(args=args)
    node = ScheduleTalker()
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    finally:
        node.destroy_node()
        rclpy.shutdown()

if __name__ == '__main__':
    main()

