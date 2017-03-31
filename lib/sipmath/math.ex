defmodule SIPmath.Math do

  @e :math.exp(1)
  @pi :math.pi

  def mod(number, divisor) do
    rem(round(number), divisor)
  end
  
  @doc """
  Inverse of the normal cumulative distrubtion function (cdf).

  x = norminv(p, mu, sigma) finds the inverse of the normal cdf with
  mean, MU, and standard deviation, SIGMA.

  Octave norminv.m

  References:
  [1] Milton Abramowitz and Irene A. Stegin, "Handbook of Mathematical Functions"
  """
  def norminv(p, mu, sigma) when p == 0 do
    -1
  end

  def norminv(p, mu, sigma) when p == 1 do
    1
  end

  def norminv(p, mu, sigma) when p > 0 and p < 1 and sigma > 0 do
    (:math.sqrt(2) * sigma * erfinv(2 * p - 1)) + mu
  end

  @doc """
  Computes the inverse of the error function

  Octave erfinv.m
  """
  def erfinv(x) when x == 0 do
    0
  end

  def erfinv(x) when x == -1 or x == 1 do
    x
  end
  
  def erfinv(x) when x > -1 and x < 1 do
    s = :math.sqrt(@pi) / 2
    z_old = 1
    z_new = :math.sqrt(-:math.log(1 - :erlang.abs(x))) * sign(x)
    while ((:erlang.abs(erf(z_new) - x) > tol * :erlang.abs(x)))
      z_old = z_new
      z_new = z_old - (erf(z_old) - x) .* :math.exp(:math.pow(z_old, 2)) * s
      if (++iterations > maxit)
        warning ("erfinv: iteration limit exceeded");
        break;
      endif
    endwhile
    y = z_new
  end

  @doc """
  Compute the error function

  https://www.gnu.org/software/octave/doc/v4.0.1/Special-Functions.html#XREFerf
  """
  def erf(x) do
    (2 / :math.sqrt(@pi)) * x
  end

end