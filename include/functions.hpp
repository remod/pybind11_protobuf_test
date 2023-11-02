#pragma once

#include "Robot.pb.h"

// Example of a function returning a protobuf object.
Robot createRobot();

// Example of a function consuming a protobuf object.
void printRobotName(const Robot& robot);
