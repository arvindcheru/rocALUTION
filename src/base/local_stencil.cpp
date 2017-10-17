#include "../utils/def.hpp"
#include "local_stencil.hpp"
#include "local_vector.hpp"
#include "stencil_types.hpp"
#include "host/host_stencil_laplace2d.hpp"
#include "host/host_vector.hpp"

#include "../utils/log.hpp"

#include <complex>

namespace paralution {

template <typename ValueType>
LocalStencil<ValueType>::LocalStencil() {

  LOG_DEBUG(this, "LocalStencil::LocalStencil()",
            "default constructor");

  this->object_name_ = "";

  // no default constructors
  LOG_INFO("no default constructor");
  FATAL_ERROR(__FILE__, __LINE__);

}

template <typename ValueType>
LocalStencil<ValueType>::~LocalStencil() {

  LOG_DEBUG(this, "LocalStencil::~LocalStencil()",
            "default destructor");

  delete this->stencil_;

}

template <typename ValueType>
LocalStencil<ValueType>::LocalStencil(unsigned int type) {

  LOG_DEBUG(this, "LocalStencil::LocalStencil()",
            "constructor with stencil type");

  assert(type == Laplace2D); // the only one at the moment

  this->object_name_ = _stencil_type_names[type];

  this->stencil_host_ = new HostStencilLaplace2D<ValueType>(this->local_backend_);
  this->stencil_ = this->stencil_host_;

}

template <typename ValueType>
int LocalStencil<ValueType>::get_ndim(void) const {

  return this->stencil_->get_ndim();
}

template <typename ValueType>
IndexType2 LocalStencil<ValueType>::get_nnz(void) const {

  return this->stencil_->get_nnz();
}

template <typename ValueType>
IndexType2 LocalStencil<ValueType>::get_nrow(void) const {

  return this->stencil_->get_nrow();
}

template <typename ValueType>
IndexType2 LocalStencil<ValueType>::get_ncol(void) const {

  return this->stencil_->get_ncol();
}


template <typename ValueType>
void LocalStencil<ValueType>::info(void) const {

  this->stencil_->info();

}

template <typename ValueType>
void LocalStencil<ValueType>::Clear(void) {


  LOG_DEBUG(this, "LocalStencil::Clear()",
            "");

  this->stencil_->SetGrid(0);


}

template <typename ValueType>
void LocalStencil<ValueType>::SetGrid(const int size) {

  LOG_DEBUG(this, "LocalStencil::SetGrid()",
            size);

  assert (size >= 0);

  this->stencil_->SetGrid(size);

}


template <typename ValueType>
void LocalStencil<ValueType>::Apply(const LocalVector<ValueType> &in, LocalVector<ValueType> *out) const {

  LOG_DEBUG(this, "LocalStencil::Apply()",
            "");

  assert(out != NULL);

  assert( ( (this->stencil_ == this->stencil_host_)  && (in.vector_ == in.vector_host_) && (out->vector_ == out->vector_host_)) ||
          ( (this->stencil_ == this->stencil_accel_) && (in.vector_ == in.vector_accel_) && (out->vector_ == out->vector_accel_)) );

  this->stencil_->Apply(*in.vector_, out->vector_);
  
}

template <typename ValueType>
void LocalStencil<ValueType>::ApplyAdd(const LocalVector<ValueType> &in, const ValueType scalar, 
                                       LocalVector<ValueType> *out) const {

  LOG_DEBUG(this, "LocalStencil::ApplyAdd()",
            "");

  assert(out != NULL);

  assert( ( (this->stencil_ == this->stencil_host_)  && (in.vector_ == in.vector_host_) && (out->vector_ == out->vector_host_)) ||
          ( (this->stencil_ == this->stencil_accel_) && (in.vector_ == in.vector_accel_) && (out->vector_ == out->vector_accel_)) );

  this->stencil_->Apply(*in.vector_, out->vector_);

}

template <typename ValueType>
void LocalStencil<ValueType>::MoveToAccelerator(void) {

  LOG_INFO("The function is not implemented (yet)!");
  FATAL_ERROR(__FILE__, __LINE__);

}

template <typename ValueType>
void LocalStencil<ValueType>::MoveToHost(void) {

  LOG_INFO("The function is not implemented (yet)!");
  FATAL_ERROR(__FILE__, __LINE__);

}


template class LocalStencil<double>;
template class LocalStencil<float>;
#ifdef SUPPORT_COMPLEX
template class LocalStencil<std::complex<double> >;
template class LocalStencil<std::complex<float> >;
#endif

}
