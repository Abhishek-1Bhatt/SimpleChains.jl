
using StrideArraysCore.LayoutPointers: zero_offsets

# conv functions

# 1d convolution
function convlayer!(f::F, _C::AbstractArray{<:Any,2}, _A::AbstractArray{<:Any,2}, _K::AbstractArray{<:Any,3}) where {F}
  C = zero_offsets(_C)
  A = zero_offsets(_A)
  K = zero_offsets(_K)
  
  for j₁ ∈ axes(C,1), o ∈ axes(K,3)
    s = zero(eltype(C))
    for k₁ ∈ axes(K,1), i ∈ axes(K,2)
      s += A[j₁ + k₁, i] * K[k₁, i, o]
    end
    C[j₁, o] = f(s)
  end
end
function convlayer!(f::F, _C::AbstractArray{<:Any,3}, _A::AbstractArray{<:Any,3}, _K::AbstractArray{<:Any,3}) where {F}
  C = zero_offsets(_C)
  A = zero_offsets(_A)
  K = zero_offsets(_K)
  
  for d ∈ axes(C,4)
    convlayer!(f, view(C,:,:,d), view(A,:,:,d), K)
  end
end
function convlayer!(∂f::F, _∂C::AbstractArray{<:Any,2}, _C::AbstractArray{<:Any,2}, _A::AbstractArray{<:Any,2}, _K::AbstractArray{<:Any,3}) where {F}
  ∂C = zero_offsets(_∂C)
  C = zero_offsets(_C)
  A = zero_offsets(_A)
  K = zero_offsets(_K)
  
  for j₁ ∈ axes(C,1), o ∈ axes(K,3)
    s = zero(eltype(C))
    for k₁ ∈ axes(K,1), i ∈ axes(K,2)
      s += A[j₁ + k₁, i] * K[k₁, i, o]
    end
    Cjo, ∂Cjo = ∂f(s)
    C[j₁, o] = Cjo
    ∂C[j₁, o] = ∂Cjo
  end
end
function convlayer!(f::F, _∂C::AbstractArray{<:Any,3}, _C::AbstractArray{<:Any,3}, _A::AbstractArray{<:Any,3}, _K::AbstractArray{<:Any,3}) where {F}
  ∂C = zero_offsets(_∂C)
  C = zero_offsets(_C)
  A = zero_offsets(_A)
  K = zero_offsets(_K)
  
  for d ∈ axes(C,4)
    convlayer!(f, view(∂C,:,:,d), view(C,:,:,d), view(A,:,:,d), K)
  end
end

# 2d convolution
function convlayer!(f::F, _C::AbstractArray{<:Any,3}, _A::AbstractArray{<:Any,3}, _K::AbstractArray{<:Any,4}) where {F}
  C = zero_offsets(_C)
  A = zero_offsets(_A)
  K = zero_offsets(_K)
  for j₁ ∈ axes(C,1), j₂ ∈ axes(C,2), o ∈ axes(K,4)
    s = zero(eltype(C))
    for k₁ ∈ axes(K,1), k₂ ∈ axes(K,2), i ∈ axes(K,3)
      s += A[j₁ + k₁, j₂ + k₂, i] * K[k₁, k₂, i, o]
    end
    C[j₁, j₂, o] = f(s)
  end
end
function convlayer!(f::F, _C::AbstractArray{<:Any,4}, _A::AbstractArray{<:Any,4}, _K::AbstractArray{<:Any,4}) where {F}
  C = zero_offsets(_C)
  A = zero_offsets(_A)
  K = zero_offsets(_K)
  for d ∈ axes(C,4)
    convlayer!(f, view(C,:,:,:,d), view(A,:,:,:,d), K)
  end
end
# 3d convolution
function convlayer!(f::F, _C::AbstractArray{<:Any,4}, _A::AbstractArray{<:Any,4}, _K::AbstractArray{<:Any,5}) where {F}
  C = zero_offsets(_C)
  A = zero_offsets(_A)
  K = zero_offsets(_K)
  for j₁ ∈ axes(C,1), j₂ ∈ axes(C,2), j₃ ∈ axes(C,3), o ∈ axes(K,5)
    s = zero(eltype(C))
    for k₁ ∈ axes(K,1), k₂ ∈ axes(K,2), k₃ ∈ axes(K,3), i ∈ axes(K,4)
      s += A[j₁ + k₁, j₂ + k₂, j₃ + k₃ - 1, i] * K[k₁, k₂, k₃, i, o]
    end
    C[j₁, j₂, j₃, o] = f(s)
  end
end
function convlayer!(f::F, _C::AbstractArray{<:Any,5}, _A::AbstractArray{<:Any,5}, _K::AbstractArray{<:Any,5}) where {F}
  C = zero_offsets(_C)
  A = zero_offsets(_A)
  K = zero_offsets(_K)
  for d ∈ axes(C,4)
    convlayer!(f, view(C,:,:,:,:,d), view(A,:,:,:,:,d), K)
  end
end

# 2d convolution
function convlayer!(∂f::F, _∂C::AbstractArray{<:Any,3}, _C::AbstractArray{<:Any,3}, _A::AbstractArray{<:Any,3}, _K::AbstractArray{<:Any,4}) where {F}
  ∂C = zero_offsets(_∂C)
  C = zero_offsets(_C)
  A = zero_offsets(_A)
  K = zero_offsets(_K)
  for j₁ ∈ axes(C,1), j₂ ∈ axes(C,2), o ∈ axes(K,4)
    s = zero(eltype(C))
    for k₁ ∈ axes(K,1), k₂ ∈ axes(K,2), i ∈ axes(K,3)
      s += A[j₁ + k₁, j₂ + k₂, i] * K[k₁, k₂, i, o]
    end
    c, ∂c = ∂f(s)
    C[j₁, j₂, o] = c
    ∂C[j₁, j₂, o] = ∂c
  end
end
function convlayer!(f::F, ∂C::AbstractArray{<:Any,4}, C::AbstractArray{<:Any,4}, A::AbstractArray{<:Any,4}, K::AbstractArray{<:Any,4}) where {F}
  for d ∈ axes(C,4)
    convlayer!(f, view(∂C,:,:,:,d), view(C,:,:,:,d), view(A,:,:,:,d), K)
    # d == first(axes(C,4)) && @show view(∂C,:,:,:,d)
  end
  # @show view(∂C,:,:,:,first(axes(∂C,4)))
end

# 3d convolution
function convlayer!(∂f::F, _∂C::AbstractArray{<:Any,4}, _C::AbstractArray{<:Any,4}, _A::AbstractArray{<:Any,4}, _K::AbstractArray{<:Any,5}) where {F}
  ∂C = zero_offsets(_∂C)
  C = zero_offsets(_C)
  A = zero_offsets(_A)
  K = zero_offsets(_K)
  for j₁ ∈ axes(C,1), j₂ ∈ axes(C,2), j₃ ∈ axes(C,3), o ∈ axes(K,5)
    s = zero(eltype(C))
    for k₁ ∈ axes(K,1), k₂ ∈ axes(K,2), k₃ ∈ axes(K,3), i ∈ axes(K,4)
      s += A[j₁ + k₁, j₂ + k₂, j₃ + k₃ - 1, i] * K[k₁, k₂, k₃, i, o]
    end
    c, ∂c = ∂f(s)
    C[j₁, j₂, j₃, o] = c
    ∂C[j₁, j₂, j₃, o] = ∂c
  end
end
function convlayer!(f::F, ∂C::AbstractArray{<:Any,5}, C::AbstractArray{<:Any,5}, A::AbstractArray{<:Any,5}, K::AbstractArray{<:Any,5}) where {F}
  for d ∈ axes(C,4)
    convlayer!(f, view(∂C,:,:,:,:,d), view(C,:,:,:,:,d), view(A,:,:,:,:,d), K)
  end
end

function convlayeradjK!(_Kadj::AbstractArray{<:Any,3}, _A::AbstractArray{<:Any,2}, _Cadj::AbstractArray{<:Any,2})
  Cadj = zero_offsets(_Cadj)
  A = zero_offsets(_A)
  Kadj = zero_offsets(_Kadj)
  for k₁ ∈ axes(Kadj,1), i ∈ axes(Kadj,2), o ∈ axes(Kadj,3)
    s = zero(eltype(Kadj))
    for j₁ ∈ axes(Cadj,1)
      s += A[j₁ + k₁, i] * Cadj[j₁ o]
    end
    Kadj[k₁, i, o] = s
  end
end
function convlayeradjK!(_Kadj::AbstractArray{<:Any,3}, _A::AbstractArray{<:Any,3}, _Cadj::AbstractArray{<:Any,3})
  Cadj = zero_offsets(_Cadj)
  A = zero_offsets(_A)
  Kadj = zero_offsets(_Kadj)
  for k₁ ∈ axes(Kadj,1), i ∈ axes(Kadj,2), o ∈ axes(Kadj,3)
    s = zero(eltype(Kadj))
    for j₁ ∈ axes(Cadj,1), d ∈ axes(Cadj,3)
      s += A[j₁ + k₁, i, d] * Cadj[j₁, o, d]
    end
    Kadj[k₁, i, o] = s
  end
end
function convlayeradjK!(_Kadj::AbstractArray{<:Any,4}, _A::AbstractArray{<:Any,3}, _Cadj::AbstractArray{<:Any,3})
  Cadj = zero_offsets(_Cadj)
  A = zero_offsets(_A)
  Kadj = zero_offsets(_Kadj)
  for k₁ ∈ axes(Kadj,1), k₂ ∈ axes(Kadj,2), i ∈ axes(Kadj,3), o ∈ axes(Kadj,4)
    s = zero(eltype(Kadj))
    for j₁ ∈ axes(Cadj,1), j₂ ∈ axes(Cadj,2)
      s += A[j₁ + k₁, j₂ + k₂, i] * Cadj[j₁, j₂, o]
    end
    Kadj[k₁, k₂, i, o] = s
  end
end
function convlayeradjK!(_Kadj::AbstractArray{<:Any,4}, _A::AbstractArray{<:Any,4}, _Cadj::AbstractArray{<:Any,4})
  Cadj = zero_offsets(_Cadj)
  A = zero_offsets(_A)
  Kadj = zero_offsets(_Kadj)
  for k₁ ∈ axes(Kadj,1), k₂ ∈ axes(Kadj,2), i ∈ axes(Kadj,3), o ∈ axes(Kadj,4)
    s = zero(eltype(Kadj))
    for j₁ ∈ axes(Cadj,1), j₂ ∈ axes(Cadj,2), d ∈ axes(Cadj,4)
      s += A[j₁ + k₁, j₂ + k₂, i, d] * Cadj[j₁, j₂, o, d]
    end
    Kadj[k₁, k₂, i, o] = s
  end
end

function convlayeradjK!(_Kadj::AbstractArray{<:Any,5}, _A::AbstractArray{<:Any,4}, _Cadj::AbstractArray{<:Any,4})
  Cadj = zero_offsets(_Cadj)
  A = zero_offsets(_A)
  Kadj = zero_offsets(_Kadj)
  for k₁ ∈ axes(Kadj,1), k₂ ∈ axes(Kadj,2), k₃ ∈ axes(Kadj,3), i ∈ axes(Kadj,4), o ∈ axes(Kadj,5)
    s = zero(eltype(Kadj))
    for j₁ ∈ axes(Cadj,1), j₂ ∈ axes(Cadj,2), j₃ ∈ axes(Cadj,3)
      s += A[j₁ + k₁, j₂ + k₂, j₃ + k₃, i] * Cadj[j₁, j₂, j₃, o]
    end
    Kadj[k₁, k₂, k₃, i, o] = s
  end
end
function convlayeradjK!(_Kadj::AbstractArray{<:Any,5}, _A::AbstractArray{<:Any,5}, _Cadj::AbstractArray{<:Any,5})
  Cadj = zero_offsets(_Cadj)
  A = zero_offsets(_A)
  Kadj = zero_offsets(_Kadj)
  for k₁ ∈ axes(Kadj,1), k₂ ∈ axes(Kadj,2), k₃ ∈ axes(Kadj,3), i ∈ axes(Kadj,4), o ∈ axes(Kadj,5)
    s = zero(eltype(Kadj))
    for j₁ ∈ axes(Cadj,1), j₂ ∈ axes(Cadj,2), j₃ ∈ axes(Cadj,3), d ∈ axes(Cadj,5)
      s += A[j₁ + k₁, j₂ + k₂, j₃ + k₃, i, d] * Cadj[j₁, j₂, j₃, o, d]
    end
    Kadj[k₁, k₂, k₃, i, o] = s
  end
end

# Cadj is padded??


function convlayeradjA!(
  _Aadj::AbstractArray{<:Any,2},
  _K::AbstractArray{T,3},
  _Cadj::AbstractArray{<:Any,2}
) where {T}
  Cadj = zero_offsets(_Cadj)
  Aadj = zero_offsets(_Aadj)
  K = zero_offsets(_K)
  I0 = size(Aadj,static(1))
  K0, K2, K3 = size(K)
  J0 = I0 - K0 + static(1)
  for j0 = 0:I0-1, i = 0:K2-1
    s = zero(T)
    for k0 = 0:K0-1, o = 0:K3-1
      ib0 = (j0 - k0 >= 0) & (j0 - k0 < J0)
      oa = ib0 ? Cadj[j0 - k0, o] : zero(T)
      s += K[k0,i,o] * oa
    end
    Aadj[j0, i] = s
  end
end
function convlayeradjA!(
  _Aadj::AbstractArray{<:Any,3},
  _K::AbstractArray{T,3},
  _Cadj::AbstractArray{<:Any,3}
) where {T}
  Cadj = zero_offsets(_Cadj)
  Aadj = zero_offsets(_Aadj)
  K = zero_offsets(_K)
  I0, _, I3 = size(Aadj)
  K0, K2, K3 = size(K)
  J0 = I0 - K0 + static(1)
  for d = 0:I3-1
    for j0 = 0:I0-1, i = 0:K2-1
      s = zero(T)
      for k0 = 0:K0-1, o = 0:K3-1
        ib0 = (j0 - k0 >= 0) & (j0 - k0 < J0)
        oa = ib0 ? Cadj[j0 - k0, o, d] : zero(T)
        s += K[k0,i,o] * oa
      end
      Aadj[j0, i, d] = s
    end
  end
end
function convlayeradjA!(
  _Aadj::AbstractArray{<:Any,3},
  _K::AbstractArray{T,4},
  _Cadj::AbstractArray{<:Any,3}
) where {T}
  Cadj = zero_offsets(_Cadj)
  Aadj = zero_offsets(_Aadj)
  K = zero_offsets(_K)
  I0, I1, _ = size(Aadj)
  K0, K1, K2, K3 = size(K)
  J0 = I0 - K0 + static(1)
  J1 = I1 - K1 + static(1)
  for j0 = 0:I0-1, j1 = 0:I1-1, i = 0:K2-1
    s = zero(T)
    for k0 = 0:K0-1, k1 = 0:K1-1, o = 0:K3-1
      ib0 = (j0 - k0 >= 0) & (j0 - k0 < J0)
      ib1 = (j1 - k1 >= 0) & (j1 - k1 < J1)
      oa = (ib0 & ib1) ? Cadj[j0 - k0, j1 - k1, o] : zero(T)
      s += K[k0,k1,i,o] * oa
      end
    Aadj[j0, j1, i] = s
  end
end
function convlayeradjA!(
  _Aadj::AbstractArray{<:Any,4},
  _K::AbstractArray{T,4},
  _Cadj::AbstractArray{<:Any,4}
) where {T}
  Cadj = zero_offsets(_Cadj)
  Aadj = zero_offsets(_Aadj)
  K = zero_offsets(_K)
  I0, I1, _, I3 = size(Aadj)
  K0, K1, K2, K3 = size(K)
  J0 = I0 - K0 + static(1)
  J1 = I1 - K1 + static(1)
  for d = 0:I3-1
    for j0 = 0:I0-1, j1 = 0:I1-1, i = 0:K2-1
      s = zero(T)
      for k0 = 0:K0-1, k1 = 0:K1-1, o = 0:K3-1
        ib0 = (j0 - k0 >= 0) & (j0 - k0 < J0)
        ib1 = (j1 - k1 >= 0) & (j1 - k1 < J1)
        oa = (ib0 & ib1) ? Cadj[j0 - k0, j1 - k1, o, d] : zero(T)
        s += K[k0,k1,i,o] * oa
      end
      Aadj[j0, j1, i, d] = s
    end
  end
end

#=
# This form is not supported by LoopVectorization:
function convlayeradjA2!(
  _Aadj,
  _K::AbstractArray{T,4},
  _Cadj
) where {T}
  Aadj = OffsetArray(_Aadj, OffsetArrays.Origin(0))
  K = OffsetArray(_K, OffsetArrays.Origin(0))
  Cadj = OffsetArray(_Cadj, OffsetArrays.Origin(0))
  I0, I1, _, I3 = size(Aadj)
  K0, K1, K2, K3 = size(K)
  J0 = I0 - K0 + static(1)
  J1 = I1 - K1 + static(1)
  # I0-1 = J0 + K0 - 2
  for d = 0:I3-1
    for j0 = 0:I0-1, j1 = 0:I1-1, i = 0:K2-1
      s = zero(T)
      # for k0 = max(0,j0+1-K0)
      for k0 = max(0,j0-(J0-1)):min(j0, K0-1),
        k1 = max(0,j1-(J1-1)):min(j1, K1-1),
        o = 0:K3-1
        s += K[K0-1-k0,K1-1-k1,i,o] * Cadj[j0 - k0, j1 - k1, o, d]
      end
      Aadj[j0, j1, i, d] = s
    end
  end
  Aadj
end
=#

# generated because `@turbo` prefers literals in indexing expressions
function convlayeradjA!(
  _Aadj::AbstractArray{<:Any,4},
  _K::AbstractArray{T,5},
  _Cadj::AbstractArray{<:Any,4}
) where {T}
  Cadj = zero_offsets(_Cadj)
  Aadj = zero_offsets(_Aadj)
  K = zero_offsets(_K)
  I0, I1, I2, _ = size(Aadj)
  K0, K1, K2, K3, K4 = size(K)
  J0 = I0 - K0 + static(1)
  J1 = I1 - K1 + static(1)
  J2 = I2 - K2 + static(1)
  for j0 = 0:I0-1, j1 = 0:I1-1, j2 = 0:I2-1, i = 0:K3-1
    s = zero(T)
    for k0 = 0:K0-1, k1 = 0:K1-1, k2 = 0:K2-1, o = 0:K4-1
      ib0 = (j0 - k0 >= 0) & (j0 - k0 < J0)
      ib1 = (j1 - k1 >= 0) & (j1 - k1 < J1)
      ib2 = (j2 - k2 >= 0) & (j2 - k2 < J2)
      oa = (ib0 & ib1 & ib2) ? Cadj[j0 - k0, j1 - k1, j2 - k2, o] : zero(T)
      s += K[k0,k1,k2,i,o] * oa
      end
    Aadj[j0, j1, j2, i] = s
  end
end
function convlayeradjA!(
  _Aadj::AbstractArray{<:Any,5},
  _K::AbstractArray{T,5},
  _Cadj::AbstractArray{<:Any,5}
) where {T}
  Cadj = zero_offsets(_Cadj)
  Aadj = zero_offsets(_Aadj)
  K = zero_offsets(_K)
  I0, I1, I2, _, I4 = size(Aadj)
  K0, K1, K2, K3, K4 = size(K)
  J0 = I0 - K0 + static(1)
  J1 = I1 - K1 + static(1)
  J2 = I2 - K2 + static(1)
  for d =  0:I4-1
    for j0 = 0:I0-1, j1 = 0:I1-1, j2 = 0:I2-1, i = 0:K3-1
      s = zero(T)
      for k0 = 0:K0-1, k1 = 0:K1-1, k2 = 0:K2-1, o = 0:K4-1
        ib0 = (j0 - k0 >= 0) & (j0 - k0 < J0)
        ib1 = (j1 - k1 >= 0) & (j1 - k1 < J1)
        ib2 = (j2 - k2 >= 0) & (j2 - k2 < J2)
        oa = (ib0 & ib1 & ib2) ? Cadj[j0 - k0, j1 - k1, j2 - k2, o, d] : zero(T)
        s += K[k0,k1,k2,i,o] * oa
      end
      Aadj[j0, j1, j2, i, d] = s
    end
  end
end

struct Conv{F,D<:Tuple{Vararg{Integer}},I<:Integer,O<:Integer}
  dim::D
  inputdim::I
  outputdim::O
  f::F
end
function Conv(f::F, dims::Tuple{Vararg{Integer,K}}, inputdim, outputdim) where {F,K}
  Conv(map(static, dims), static(inputdim), static(outputdim), f)
end
fast_fuse(c::Conv) = fast_fuse(getfield(c,:f))

_fused_fun(c, ::True) = getfield(c,:f)
_fused_fun(_, ::False) = identity
fused_fun(c) = _fused_fun(c, fast_fuse(c))

_unfused_fun(_, ::True) = identity
_unfused_fun(c, ::False) = getfield(c,:f)
unfused_fun(c) = Activation(_unfused_fun(c, fast_fuse(c)))

dimsum(c::Conv) = ArrayInterface.reduce_tup(+,c.dim)
dimprod(c::Conv) = ArrayInterface.reduce_tup(*,c.dim)

function Base.show(io::IO, c::Conv)
  print(io, "Conv $(c.dim) mapping $(c.inputdim) to $(c.outputdim)")
  if c.f !== identity
    println(io)
    show(io, Activation(c.f))
  end
end


@inline bsub(::Tuple{}, ::Number) = ()
@inline bsub(x::Tuple{T}, y::Number) where {T} = (only(x) - y,)
@inline bsub(x::Tuple{T0,T1,Vararg}, y::Number) where {T0,T1} = (first(x) - y, bsub(Base.tail(x), y)...)

@inline badd(::Tuple{}, ::Number) = ()
@inline badd(x::Tuple{T}, y::Number) where {T} = (only(x) + y,)
@inline badd(x::Tuple{T0,T1,Vararg}, y::Number) where {T0,T1} = (first(x) + y, badd(Base.tail(x), y)...)

function getoutputdim(c::Conv{F,D}, inputdim::Tuple{Vararg{Integer,N}}) where {F,N,D<:Tuple{Vararg{Integer,N}}}
  badd(map(-, inputdim, c.dim), static(1))
end
function getoutputdim(c::Conv{F,D}, inputdim::Tuple{Vararg{Integer,N0}}) where {F,N0,N1,D<:Tuple{Vararg{Integer,N1}}}
  if N1+1 == N0
    (getoutputdim(c, Base.front(inputdim))..., c.outputdim)
  else
    @assert N1+2 == N0
    (getoutputdim(c, Base.front(inputdim))..., last(inputdim))
  end
end


numparam(c::Conv) = dimprod(c)*c.inputdim*c.outputdim
parameter_free(::Conv) = false
function numparam(c::Conv, inputdim::Tuple{Vararg{Integer}})
  numparam(c), getoutputdim(c, inputdim)
end

function getparams(c::Conv, p::Ptr{T}) where {T}
  K = PtrArray(p, (c.dim..., c.inputdim, c.outputdim))
  K, p + sizeof(T) * length(K)
end

function output_size(::Val{T}, c::Conv, inputdim::Tuple) where {T}
  g1, outputdim = numparam(c, inputdim)
  g2 = prod(outputdim)
  align(static_sizeof(T) * g1) + 2align(static_sizeof(T) * g2), outputdim
end

function init_params!(c::Conv, p, inputdim)
  K, p = getparams(c, p)
  gn = Base.FastMath.sqrt_fast(eltype(K)(length(c.dim)/dimsum(c)))
  randn!(local_rng(), K, static(0), static(0), gn)
  return p, getoutputdim(c, inputdim)
end

function alloc_return(outputdim, p)
  R = PtrArray(p, outputdim)
  R, p + align(sizeof(eltype(R))*length(R))
end

#TODO: DRY with dense
function get∂C(::F, outputdim, ∂Cp::Ptr{T}) where {F,T}
  ∂C = PtrArray(reinterpret(Ptr{T}, ∂Cp), outputdim)
  ∂Cp += align(length(∂C)*sizeof(T))
  ∂C, ∂Cp
end
function get∂C(::F, outputdim, ∂Cp::Ptr{T}, ::False) where {F,T}
  lenC = ArrayInterface.reduce_tup(*, outputdim)
  ∂C = PtrArray(reinterpret(Ptr{T}, ∂Cp), (lenC,))
  ∂Cp += align(lenC*sizeof(T))
  ∂C, ∂Cp
end
function get∂C(::typeof(relu), outputdim, ∂Cp::Ptr)
  ∂C = PtrArray(Ptr{Bit}(∂Cp), outputdim)
  ∂Cp += align((last(StrideArraysCore.strides(∂C))>>>3)*last(outputdim))
  ∂C, ∂Cp
end
function get∂C(::typeof(identity), _, ∂Cp::Ptr)
  nothing, ∂Cp
end

function (c::Conv)(A::AbstractArray{T0}, p::Ptr{T1}, pu::Ptr{UInt8}) where {T0,T1}
  T = promote_type(T0, T1)
  outputdim = getoutputdim(c, size(A))
  C, pu2 = alloc_return(outputdim, Ptr{T}(pu))
  K, p = getparams(c, p)
  convlayer!(fused_fun(c), C, A, K)
  call!(C, unfused_fun(c), p, Ptr{UInt8}(pu2))
  C, p, Ptr{UInt8}(pu2)
end

function valgrad_layer!(pg::Ptr{T}, c::Conv{typeof(identity)}, A, p::Ptr{T}, pu::Ptr{UInt8}) where {T}
  outputdim = getoutputdim(c, size(A))
  R, pu3 = alloc_return(outputdim, Ptr{T}(pu))
  K, p2 = getparams(c, p)
  convlayer!(identity, R, A, K)
  pg + length(K)*sizeof(T), R, p2, Ptr{UInt8}(pu3)
end
function valgrad_layer!(pg::Ptr{T}, c::Conv, A, p::Ptr{T}, pu::Ptr{UInt8}) where {T}
  outputdim = getoutputdim(c, size(A))
  # we want to allocate ∂C in front of C
  ∂C, pu2 = get∂C(c.f, outputdim, Ptr{T}(pu))
  C, pu3 = alloc_return(outputdim, Ptr{T}(pu2))
  K, p2 = getparams(c, p)
  convlayer!(∂(fused_fun(c)), ∂C, C, A, K)
  _valgrad_layer!(
    ∂C, C, pg + length(K)*sizeof(T),
    unfused_fun(c), C, p2, Ptr{UInt8}(pu3)
  )
end
function pullback!(pg::Ptr{T}, c::Conv, C̄, A, p::Ptr{T}, pu::Ptr{UInt8}, pu2::Ptr{UInt8}) where {T}
  _pullback!(pg, c, C̄, A, p, pu)
  return A, pu2
end
function _pullback!(pg::Ptr{T}, c::Conv, C̄, A, p::Ptr{T}, pu::Ptr{UInt8}) where {T}
  _pullback_param!(pg, c, C̄, A, pu)
  _pullback_A!(c, C̄, A, p)
  return
end
function _pullback_A!(c::Conv, C̄, A, p::Ptr{T}) where {T}
  convlayeradjA!(A, first(getparams(c, p)), C̄) # overwrite A
  return
end
function pullback_param!(pg::Ptr{T}, c::Conv, C̄, A, ::Ptr{T}, pu::Ptr{UInt8}) where {T}
  _pullback_param!(pg, c, C̄, A, pu)
end
function _pullback_param!(pg::Ptr{T}, c::Conv, C̄, A, pu::Ptr{UInt8}) where {T}
  ∂C = first(get∂C(c.f, size(C̄), Ptr{T}(pu)))
  update_C̄!(c.f, C̄, ∂C)
  convlayeradjK!(first(getparams(c, pg)), A, C̄)
  return
end

