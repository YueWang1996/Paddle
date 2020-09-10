Paddle with musl lib support
==============================

# changes:

1. add other backtrace implements
2. fix check_symbol invoking failure
3. rm nltk, opencv-python, matplotlib deps
4. use openblas instead of mkl and mkl_ml
5. disable crypto feature because protobuf lib compiling error

# todos:



# build

```sh
    mkdir build && cd build
    cmake .. -DPY_VERSION=3.7 -DWITH_CRYPTO=OFF -DWITH_MKL=OFF -DWITH_GPU=OFF -DWITH_TESTING=OFF -DCMAKE_BUILD_TYPE=Release
```