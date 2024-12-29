import rclpy
from rclpy.node import Node
from std_msgs.msg import String
import os


class ScheduleListener(Node):
    def __init__(self):
        super().__init__('schedule_listener')
        self.subscription = self.create_subscription(
            String,
            'schedule_topic',
            self.listener_callback,
            10
        )
        self.subscription  # prevent unused variable warning

    def listener_callback(self, msg):
        self.get_logger().info(f'受信したメッセージ: "{msg.data}"')

        # 予定が現在時刻と一致する場合にGUI通知を送信
        if "15:00" in msg.data:
            os.system('notify-send "お菓子の時間です！"')

def main(args=None):
    rclpy.init(args=args)
    node = ScheduleListener()
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    finally:
        node.destroy_node()
        rclpy.shutdown()

if __name__ == '__main__':
    main()

