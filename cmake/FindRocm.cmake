# cmake/FindROCM.cmake

# default ROCm path
set(ROCM_PATH "" CACHE PATH "Path to ROCm installation (optional)")

# If the user does not specify the ROCm path, try to find it from environment variables or common locations
if(NOT ROCM_PATH)
    if(DEFINED ENV{ROCM_PATH})
        set(ROCM_PATH $ENV{ROCM_PATH})
    elseif(EXISTS /opt/rocm)
        set(ROCM_PATH /opt/rocm)
    endif()
endif()

# 查找ROCm的include目录
find_path(ROCM_INCLUDE_DIRS
    NAMES hip/hip_runtime.h
    HINTS ${ROCM_PATH}/include
)

# 查找ROCm的库目录
find_library(ROCM_HIPRT_LIBRARY
    NAMES hiprtc
    HINTS ${ROCM_PATH}/lib ${ROCM_PATH}/lib64
)

# 查找hipcc编译器
find_program(ROCM_HIPCC_EXECUTABLE
    NAMES hipcc
    HINTS ${ROCM_PATH}/bin
)

# 检查是否找到所有必要的部分
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(ROCM
    REQUIRED_VARS ROCM_INCLUDE_DIRS ROCM_HIPRT_LIBRARY ROCM_HIPCC_EXECUTABLE
)

# 如果找到了ROCm，设置一些额外的变量
if(ROCM_FOUND)
    # 设置ROCm版本
    execute_process(COMMAND ${ROCM_HIPCC_EXECUTABLE} --version
        OUTPUT_VARIABLE ROCM_VERSION_OUTPUT
        ERROR_QUIET
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    string(REGEX MATCH "[0-9]+\\.[0-9]+" ROCM_VERSION "${ROCM_VERSION_OUTPUT}")

    # 导出变量供其他地方使用
    set(ROCM_LIBRARIES ${ROCM_HIPRT_LIBRARY})
    set(ROCM_COMPILE_OPTIONS "-Xcompiler -fPIC")
    mark_as_advanced(ROCM_INCLUDE_DIRS ROCM_LIBRARIES ROCM_HIPCC_EXECUTABLE)
endif()
