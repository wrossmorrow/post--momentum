
λ = 1
Rf(β, α) = [   β        λ; 
            -α*β (1 - α*λ)]

α = 0.05
β = 0.4

ϵ = 8
S = inv([ 1  0 ;
          α  1 ])

function err(k)
    R = Rf(β, α)
    sum( ( ((R^(k-i))*([ϵ; -α*ϵ]) )[2] )^2 for i = 1:k )
end

function err2(k, α, β)
    R = Rf(β, α)
    x = [ϵ; -α*ϵ]
    s = 0
    z = []
    for i = 1:k
      s = s + x[2]^2
      x = R*x
      push!(z, s)
    end
    return z
end

err2(100)[50] - err(50)

function geosumgen(R) 
  Λ, U = eig(R)
  (b,k) -> begin; 
    Λsum = (1./(1 - Λ)).*(1 - Λ.^k); 
    real(U*(Λsum.*(U\b))); 
  end
end

function runmomentum(A,b,k, ϵ)
  z = zeros(length(b))
  w = 3*ones(length(b))
  for i = 1:k
    z = β*z + (A*w - b) + ϵ*randn(1)
    w = w - α*z
  end
  return (z[1],w[1])
end

function runmomentum2(A,b,k, ϵ)
  z = zeros(length(b))
  w = 3*ones(length(b))
  fx = []
  for i = 1:k
    z = β*z + (A*w - b) + ϵ*randn(1)
    w = w - α*z
    push!(fx, w[1]*w[1])
  end
  return fx
end

k = 150
d = mean([runmomentum2(1,0, k, ϵ) for i = 1:100])
e = err2(k)
d2 = [runmomentum(1,0, i, 0.)[2]^2 for i = 1:k]

plot(d,".")
plot(d2+e)
#plot(d2)

plot(err2(200, 0.01, 0))
