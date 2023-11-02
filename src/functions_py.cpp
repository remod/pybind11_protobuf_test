#include <pybind11/pybind11.h>
#include <pybind11_protobuf/native_proto_caster.h>

#include "functions.hpp"

PYBIND11_MODULE(functions_py, m) {
    pybind11_protobuf::ImportNativeProtoCasters();
    m.def("create_robot", &createRobot);
    m.def("print_robot_name", &printRobotName);
}
