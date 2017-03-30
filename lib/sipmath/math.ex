defmodule SIPmath.Math do

  def mod(number, divisor) do
    rem(round(number), divisor)
  end
  
  @doc """
  Inverse of the normal cumulative distrubtion function (cdf).

  x = norminv(p, mu, sigma) finds the inverse of the normal cdf with
  mean, MU, and standard deviation, SIGMA.

  References:
  [1] M. Abramowitz and I. A. Stegin, "Handnook of Mathematical Functions"
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

  def erfinv(a) do
      a
  end

end