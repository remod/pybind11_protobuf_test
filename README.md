# Test pybind11_protobuf

This repository contains code to test pybind11_protobuf in Ubuntu 20.04.

## Usage

To run, clone this repository, navigate to its root directory, and run

```
docker build -t pybind11_protobuf_test .
docker run pybind11_protobuf_test
```

This will build the docker image and run the test.

The build contains the following steps:

1. Install necessary dependencies.
1. Generate C++ and Python code from the protobuf definition stored in `proto/Robot.proto`.
1. Compile a C++ library containing functions which operate on the generated C++ code (i.e. produce and consume protobuf message).
1. Bind the library as a Python module using `pybind11_protobuf`.

When running, a Python script loads the module and calls the bound functions, performing a full round-trip from Python to C++ and back.

Have a look at the `Dockerfile` for details.

## Limitations

The following limitations were discovered:

* The older Ubuntu version 20.04 does not allow to install the latest software.
  At the time of writing, both the latest `libprotobuf-dev` and `protobuf-compiler` debian packages have the version `3.6.1-2ubuntu5.2`.
  To make the test succeed, one may not install a `protobuf` python package newer than version `3.20.X`.
  Also, `pybind11_protobuf`s `proto_caster_impl.h` required a patch to work with this old version.
* `pybind11_protobuf` officially uses bazel as build system.
  The `CMakeLists.txt` is experimental and not CI-tested.
  See [this comment](https://github.com/pybind/pybind11_protobuf/pull/73#issuecomment-1447069957) for more information.
  This should not be a big issue as we anyway have to create a debian package ourselves, so we can create our own version.
* We did not find a solution to make the test work with shared libraries, only with static ones.
* By default, the Python <-> C++ conversions are implemented by serialization & deserialization.
  This is slow but safe.
  To change this, one can use the bazel build option `--define=use_fast_cpp_protos=true` which will change the backend of the Python message to C++, which results in a speed up.
  More information can be found [here](https://github.com/pybind/pybind11_protobuf/tree/main#c-native-vs-python-native-types).
  This option has not been evaluated in this test.

All required changes to the original `pybind11_protobuf` repository are combined in https://github.com/remod/pybind11_protobuf/commit/1f3a6b982f89b82af356340846250c076f70b276.
