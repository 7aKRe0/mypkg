cmake_minimum_required(VERSION 3.8)
project(mypkg)

find_package(ament_cmake REQUIRED)

# 必要な依存関係をエクスポート
ament_export_dependencies(rosidl_default_runtime)
ament_package()

