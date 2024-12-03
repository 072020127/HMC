# HDDT
Distrubuted DNN Training on Heterogeneous GPUs

## 编译

1. 创建编译目录
```
mkdir build && cd build
```

2. 生成makefile
```
cmake ..
```

支持的参数
```
-DBUILD_STATIC_LIB=ON # 开启静态库编译
```

3. 编译
```
make
```

## 环境依赖
1. 计算库驱动 CUDA/DTK/CNRT etc.
2. openMPI
    `sudo apt install openmpi-bin openmpi-common libopenmpi-dev`
3. Miniconda
    - `https://docs.anaconda.com/miniconda/`
    - `conda create -n py310 python=3.10`
4. pytorch
    - `pip3 install torch torchvision torchaudio`
    - `python -c "import torch; print(torch.cuda.is_available())"`
5. glog
    - `sudo apt-get install libgoogle-glog-dev`


## python包
项目通过pybind11将核心功能打包供python使用

要构建python包，首先需要拉取pybind11库以支持模块构建：
- 项目根目录执行`git submodule update --init --recursive`

然后开启python模块支持，并重新构建编译项目：
- cmake命令指定-DBUILD_PYTHON_MOD=ON，按照前面步骤重新编译整个项目
- python环境需安装build库 `pip install build`
- 构建wheel包 `python -m build`
- 安装wheel包 `pip install dist/xxx.whl`
