#include "../../utils/def.hpp"
#include "gpu_allocate_free.hpp"
#include "gpu_utils.hpp"
#include "cuda_kernels_general.hpp"
#include "../../utils/allocate_free.hpp"

#include <cmath>
#include <complex>

#include <cuda.h>

namespace paralution {

#ifdef PARALUTION_CUDA_PINNED_MEMORY

template <typename DataType>
void allocate_host(const int size, DataType **ptr) {

  LOG_DEBUG(0, "allocate_host()",
            size);

  if (size > 0) {

    assert(*ptr == NULL);

    //    *ptr = new DataType[size];

    cudaMallocHost((void **)ptr, size*sizeof(DataType));
    CHECK_CUDA_ERROR(__FILE__, __LINE__);

    LOG_DEBUG(0, "allocate_host()",
              *ptr);

    assert(*ptr != NULL);

  }

}

template <typename DataType>
void free_host(DataType **ptr) {

  LOG_DEBUG(0, "free_host()",
            *ptr);

  assert(*ptr != NULL);

  //  delete[] *ptr;
  cudaFreeHost(*ptr);
  CHECK_CUDA_ERROR(__FILE__, __LINE__);

  *ptr = NULL;

}

#endif

template <typename DataType>
void allocate_gpu(const int size, DataType **ptr) {

  LOG_DEBUG(0, "allocate_gpu()",
            size);

  if (size > 0) {

    assert(*ptr == NULL);

    cudaMalloc( (void **)ptr, size*sizeof(DataType));
    CHECK_CUDA_ERROR(__FILE__, __LINE__);

    assert(*ptr != NULL);

  }

}

template <typename DataType>
void free_gpu(DataType **ptr) {

  LOG_DEBUG(0, "free_gpu()",
            *ptr);

  assert(*ptr != NULL);

  cudaFree(*ptr);
  CHECK_CUDA_ERROR(__FILE__, __LINE__);

  *ptr = NULL;

}

template <typename DataType>
void set_to_zero_gpu(const int blocksize,
                     const int max_threads,
                     const int size, DataType *ptr) {

  LOG_DEBUG(0, "set_to_zero_gpu()",
            "size =" << size << 
            " ptr=" << ptr);

  if (size > 0) {

    assert(ptr != NULL);

    cudaMemset(ptr, 0, size*sizeof(DataType));
    CHECK_CUDA_ERROR(__FILE__, __LINE__);

/*
    int s = size ;
    int k = (size/blocksize)/max_threads + 1;
    if (k > 1) s = size / k;

    dim3 BlockSize(blocksize);
    dim3 GridSize(s / blocksize + 1);

    kernel_set_to_zeros<DataType, int> <<<GridSize, BlockSize>>> (size, ptr);

    CHECK_CUDA_ERROR(__FILE__, __LINE__);
*/

/*
    // 1D accessing, no stride
    dim3 BlockSize(blocksize);
    dim3 GridSize(size / blocksize + 1);

    kernel_set_to_zeros<DataType, int> <<<GridSize, BlockSize>>> (size, ptr);

    CHECK_CUDA_ERROR(__FILE__, __LINE__);
*/

  }

}

template <typename DataType>
void set_to_one_gpu(const int blocksize,
                    const int max_threads,
                    const int size, DataType *ptr) {

  LOG_DEBUG(0, "set_to_zero_gpu()",
            "size =" << size << 
            " ptr=" << ptr);

  if (size > 0) {

    assert(ptr != NULL);

/*
    int s = size ;
    int k = (size/blocksize)/max_threads + 1;
    if (k > 1) s = size / k;

    dim3 BlockSize(blocksize);
    dim3 GridSize(s / blocksize + 1);

    kernel_set_to_ones<DataType, int> <<<GridSize, BlockSize>>> (size, ptr);

    CHECK_CUDA_ERROR(__FILE__, __LINE__);
*/

    // 1D accessing, no stride
    dim3 BlockSize(blocksize);
    dim3 GridSize(size / blocksize + 1);

    kernel_set_to_ones<DataType, int> <<<GridSize, BlockSize>>> (size, ptr);

  }

}

template <>
void set_to_one_gpu(const int blocksize,
                    const int max_threads,
                    const int size, std::complex<double> *ptr) {

  LOG_DEBUG(0, "set_to_zero_gpu()",
            "size =" << size << 
            " ptr=" << ptr);

  if (size > 0) {

    assert(ptr != NULL);

/*
    int s = size ;
    int k = (size/blocksize)/max_threads + 1;
    if (k > 1) s = size / k;

    dim3 BlockSize(blocksize);
    dim3 GridSize(s / blocksize + 1);

    kernel_set_to_ones<DataType, int> <<<GridSize, BlockSize>>> (size, ptr);

    CHECK_CUDA_ERROR(__FILE__, __LINE__);
*/

    // 1D accessing, no stride
    dim3 BlockSize(blocksize);
    dim3 GridSize(size / blocksize + 1);

    kernel_set_to_ones<cuDoubleComplex, int> <<<GridSize, BlockSize>>> (size, (cuDoubleComplex*)ptr);

  }

}

template <>
void set_to_one_gpu(const int blocksize,
                    const int max_threads,
                    const int size, std::complex<float> *ptr) {

  LOG_DEBUG(0, "set_to_zero_gpu()",
            "size =" << size << 
            " ptr=" << ptr);

  if (size > 0) {

    assert(ptr != NULL);

/*
    int s = size ;
    int k = (size/blocksize)/max_threads + 1;
    if (k > 1) s = size / k;

    dim3 BlockSize(blocksize);
    dim3 GridSize(s / blocksize + 1);

    kernel_set_to_ones<DataType, int> <<<GridSize, BlockSize>>> (size, ptr);

    CHECK_CUDA_ERROR(__FILE__, __LINE__);
*/

    // 1D accessing, no stride
    dim3 BlockSize(blocksize);
    dim3 GridSize(size / blocksize + 1);

    kernel_set_to_ones<cuFloatComplex, int> <<<GridSize, BlockSize>>> (size, (cuFloatComplex*)ptr);

  }

}


#ifdef PARALUTION_CUDA_PINNED_MEMORY

template void allocate_host<float                >(const int size, float                **ptr);
template void allocate_host<double               >(const int size, double               **ptr);
#ifdef SUPPORT_COMPLEX
template void allocate_host<std::complex<float>  >(const int size, std::complex<float>  **ptr);
template void allocate_host<std::complex<double> >(const int size, std::complex<double> **ptr);
#endif
template void allocate_host<int                  >(const int size, int                  **ptr);
template void allocate_host<unsigned int         >(const int size, unsigned int         **ptr);
template void allocate_host<char                 >(const int size, char                 **ptr);

template void free_host<float                >(float                **ptr);
template void free_host<double               >(double               **ptr);
#ifdef SUPPORT_COMPLEX
template void free_host<std::complex<float>  >(std::complex<float>  **ptr);
template void free_host<std::complex<double> >(std::complex<double> **ptr);
#endif
template void free_host<int                  >(int                  **ptr);
template void free_host<unsigned int         >(unsigned int         **ptr);
template void free_host<char                 >(char                 **ptr);

#endif

template void allocate_gpu<float                >(const int size, float                **ptr);
template void allocate_gpu<double               >(const int size, double               **ptr);
#ifdef SUPPORT_COMPLEX
template void allocate_gpu<std::complex<float>  >(const int size, std::complex<float>  **ptr);
template void allocate_gpu<std::complex<double> >(const int size, std::complex<double> **ptr);
#endif
template void allocate_gpu<int                  >(const int size, int                  **ptr);
template void allocate_gpu<unsigned int         >(const int size, unsigned int         **ptr);
template void allocate_gpu<char                 >(const int size, char                 **ptr);

template void free_gpu<float                >(float                **ptr);
template void free_gpu<double               >(double               **ptr);
#ifdef SUPPORT_COMPLEX
template void free_gpu<std::complex<float>  >(std::complex<float>  **ptr);
template void free_gpu<std::complex<double> >(std::complex<double> **ptr);
#endif
template void free_gpu<int                  >(int                  **ptr);
template void free_gpu<unsigned int         >(unsigned int         **ptr);
template void free_gpu<char                 >(char                 **ptr);

template void set_to_zero_gpu<float                >(const int blocksize, const int max_threads, const int size, float                *ptr);
template void set_to_zero_gpu<double               >(const int blocksize, const int max_threads, const int size, double               *ptr);
#ifdef SUPPORT_COMPLEX
template void set_to_zero_gpu<std::complex<float>  >(const int blocksize, const int max_threads, const int size, std::complex<float>  *ptr);
template void set_to_zero_gpu<std::complex<double> >(const int blocksize, const int max_threads, const int size, std::complex<double> *ptr);
#endif
template void set_to_zero_gpu<int                  >(const int blocksize, const int max_threads, const int size, int                  *ptr);

template void set_to_one_gpu<float                >(const int blocksize, const int max_threads, const int size, float                *ptr);
template void set_to_one_gpu<double               >(const int blocksize, const int max_threads, const int size, double               *ptr);
#ifdef SUPPORT_COMPLEX
template void set_to_one_gpu<std::complex<float>  >(const int blocksize, const int max_threads, const int size, std::complex<float>  *ptr);
template void set_to_one_gpu<std::complex<double> >(const int blocksize, const int max_threads, const int size, std::complex<double> *ptr);
#endif
template void set_to_one_gpu<int                  >(const int blocksize, const int max_threads, const int size, int                  *ptr);

}
