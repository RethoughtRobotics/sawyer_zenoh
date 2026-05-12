cmake_minimum_required(VERSION 3.5)
project(intera_core_msgs)

# Default to C99
if(NOT CMAKE_C_STANDARD)
  set(CMAKE_C_STANDARD 99)
endif()

# Default to C++14
if(NOT CMAKE_CXX_STANDARD)

  set(CMAKE_CXX_STANDARD 14)
endif()

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# find dependencies
find_package(ament_cmake REQUIRED)
find_package(std_msgs REQUIRED)
find_package(geometry_msgs REQUIRED)
find_package(sensor_msgs REQUIRED)
find_package(action_msgs REQUIRED)
find_package(builtin_interfaces REQUIRED)
find_package(rosidl_default_generators REQUIRED)

rosidl_generate_interfaces(${PROJECT_NAME}
	"msg/AnalogIOState.msg"
	"msg/AnalogIOStates.msg"
	"msg/AnalogOutputCommand.msg"
	"msg/RobotAssemblyState.msg"
	"msg/CameraControl.msg"
	"msg/CameraSettings.msg"
	"msg/CollisionAvoidanceState.msg"
	"msg/CollisionDetectionState.msg"
	"msg/DigitalIOState.msg"
	"msg/DigitalIOStates.msg"
	"msg/DigitalOutputCommand.msg"
	"msg/EndpointNamesArray.msg"
	"msg/EndpointState.msg"
	"msg/EndpointStates.msg"
	"msg/HeadPanCommand.msg"
	"msg/HeadState.msg"
	"msg/HomingCommand.msg"
	"msg/HomingState.msg"
	"msg/InteractionControlCommand.msg"
	"msg/InteractionControlState.msg"
	"msg/IOStatus.msg"
	"msg/IOComponentCommand.msg"
	"msg/IOComponentConfiguration.msg"
	"msg/IOComponentStatus.msg"
	"msg/IODataStatus.msg"
	"msg/IODeviceConfiguration.msg"
	"msg/IODeviceStatus.msg"
	"msg/IONodeConfiguration.msg"
	"msg/IONodeStatus.msg"
	"msg/JointCommand.msg"
	"msg/JointLimits.msg"
	"msg/NavigatorState.msg"
	"msg/NavigatorStates.msg"
	"msg/SEAJointState.msg"
	"msg/URDFConfiguration.msg"
	"srv/IOComponentCommandSrv.srv"
	"srv/SolvePositionFK.srv"
	"srv/SolvePositionIK.srv"
	"action/CalibrationCommand.action"
	DEPENDENCIES std_msgs geometry_msgs sensor_msgs action_msgs builtin_interfaces
)

install(
	FILES mapping_rules.yaml
	DESTINATION share/${PROJECT_NAME})


if(BUILD_TESTING)
  find_package(ament_lint_auto REQUIRED)
  # the following line skips the linter which checks for copyrights
  # uncomment the line when a copyright and license is not present in all source files
  #set(ament_cmake_copyright_FOUND TRUE)
  # the following line skips cpplint (only works in a git repo)
  # uncomment the line when this package is not in a git repo
  #set(ament_cmake_cpplint_FOUND TRUE)
  ament_lint_auto_find_test_dependencies()
endif()

ament_package()
