import os
import rclpy
from rclpy.node import Node
from std_msgs.msg import String

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
        self.get_logger().info(f"Received: {msg.data}")

        # 予定がある場合だけデスクトップ通知を表示
        if "お菓子の時間" in msg.data:
            os.system('notify-send "ALERT" "Okashi no jikan desu!"')
        elif "夕食の準備" in msg.data:
            os.system('notify-send "ALERT" "Yushoku no junbi wo shite kudasai!"')
        elif "お風呂の時間" in msg.data:
            os.system('notify-send "ALERT" "Ofuro no jikan desu!"')
        else:
            # 予定がない場合はログ出力のみ
            self.get_logger().info("No current events, no desktop notification.")

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

