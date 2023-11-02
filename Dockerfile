FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y cmake build-essential git libprotobuf-dev protobuf-compiler python3-dev python3-pip

# Protobuf must not be newer than 3.20.X.
# Under Ubuntu 20.04 could also install `python3-protobuf` (version 3.12.4).
RUN pip3 install -v "protobuf==3.20.0"

RUN git clone --recurse-submodules https://github.com/remod/pybind11_protobuf_test && \
    cd pybind11_protobuf_test && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j

RUN protoc -I=pybind11_protobuf_test/proto --python_out=pybind11_protobuf_test/build pybind11_protobuf_test/proto/Robot.proto

CMD cd pybind11_protobuf_test/build && \
    python3 -c 'import functions_py; print(functions_py.create_robot())'
