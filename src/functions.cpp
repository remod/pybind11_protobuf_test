#include "functions.hpp"

#include <iostream>

Robot createRobot() {
  Robot robot;
  robot.set_id(1);
  robot.set_name("ANYmal");
  return robot;
}

void printRobotName(const Robot& robot) {
  std::cout << robot.name() << std::endl;
}
