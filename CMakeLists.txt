cmake_minimum_required(VERSION 3.16)

project(pybind11_protobuf_test)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)

find_package(Python3 REQUIRED COMPONENTS Development Interpreter)
find_package(Protobuf REQUIRED)

add_subdirectory(extern/pybind11 EXCLUDE_FROM_ALL)
add_subdirectory(extern/pybind11_protobuf EXCLUDE_FROM_ALL)

protobuf_generate_cpp(PROTO_SRCS PROTO_HDRS proto/Robot.proto)
protobuf_generate_python(PROTO_PY proto/Robot.proto)

# Create a library that contains functions operating on the protobuf message.
add_library(functions
    src/functions.cpp
    ${PROTO_SRCS}
)
target_include_directories(functions
    PUBLIC
        include
        ${CMAKE_CURRENT_BINARY_DIR} # Contains the generated protobuf header.
)
target_link_libraries(functions
    PRIVATE
        protobuf::libprotobuf
)

# Create a (python-independent) executable to validate the functions.
add_executable(main
    src/main.cpp
)
target_include_directories(main
    PRIVATE
        include
)
target_link_libraries(main
    PRIVATE
        functions
)

# Create a python module binding the functions.
pybind11_add_module(functions_py
    src/functions_py.cpp
)
target_include_directories(functions_py
    PRIVATE
        include
        extern/pybind11_protobuf
        ${CMAKE_CURRENT_BINARY_DIR}
)
target_link_libraries(functions_py
    PRIVATE
        functions
        pybind11_native_proto_caster
)
