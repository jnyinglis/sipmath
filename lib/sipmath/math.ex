defmodule SIPmath.Math do
  @moduledoc false

  # @e :math.exp(1)
  # @pi :math.pi

  # Coefficients in rational approximations.
  @a1 -39.696830286653757
  @a2 220.9460984245205
  @a3 -275.92851044696869
  @a4 138.357751867269
  @a5 -30.66479806614716
  @a6 2.5066282774592392

  @b1 -54.476098798224058
  @b2 161.58583685804089
  @b3 -155.69897985988661
  @b4 66.80131188771972
  @b5 -13.280681552885721

  @c1 -0.0077848940024302926
  @c2 -0.32239645804113648
  @c3 -2.4007582771618381
  @c4 -2.5497325393437338
  @c5 4.3746641414649678
  @c6 2.9381639826987831

  @d1 0.0077846957090414622
  @d2 0.32246712907003983
  @d3 2.445134137142996
  @d4 3.7544086619074162

  # Define break-points.
  @low_point 0.02425
  @high_point 1 - @low_point

  @spec hdr_uniform(seed_value :: pos_integer(), pm_index :: pos_integer()) :: number()
  def hdr_uniform(seed_value, pm_index) do
    mod(
      (mod(
         :math.pow(seed_value + 1_000_000, 2) + (seed_value + 1_000_000) * (pm_index + 10_000_000),
         99_999_989
       ) + 1_000_007) *
        (mod(
           :math.pow(pm_index + 10_000_000, 2) +
             (pm_index + 10_000_000) *
               mod(
                 :math.pow(seed_value + 1_000_000, 2) +
                   (seed_value + 1_000_000) * (pm_index + 10_000_000),
                 99_999_989
               ),
           99_999_989
         ) + 1_000_013),
      2_147_483_647
    ) / 2_147_483_647
  end

  @spec hdr_normal(
          mean :: integer(),
          std_dev :: number(),
          seed_value :: pos_integer(),
          pm_index :: pos_integer()
        ) :: number()
  def hdr_normal(mean, std_dev, seed_value, pm_index) do
    if std_dev != 0 do
      norminv(
        mod(
          (mod(
             :math.pow(seed_value + 1_000_000, 2) +
               (seed_value + 1_000_000) * (pm_index + 10_000_000),
             99_999_989
           ) + 1_000_007) *
            (mod(
               :math.pow(pm_index + 10_000_000, 2) +
                 (pm_index + 10_000_000) *
                   mod(
                     :math.pow(seed_value + 1_000_000, 2) +
                       (seed_value + 1_000_000) * (pm_index + 10_000_000),
                     99_999_989
                   ),
               99_999_989
             ) + 1_000_013),
          2_147_483_647
        ) / 2_147_483_647,
        mean,
        std_dev
      )
    else
      mean
    end
  end

  @spec mod(number :: number(), divisor :: number()) :: number()
  def mod(number, divisor) do
    rem(round(number), divisor)
  end

  @doc """
  Inverse of the normal cumulative distrubtion function (cdf).

  x = norminv(p, mu, sigma) finds the inverse of the normal cdf with
  mean, MU, and standard deviation, SIGMA.

  """
  @spec norminv(p :: float(), mu :: float(), sigma :: float()) :: float()
  def norminv(p, _mu, _sigma) when p == 0 do
    -1
  end

  def norminv(p, _mu, _sigma) when p == 1 do
    1
  end

  def norminv(p, mu, sigma) when p > 0 and p < 1 and sigma > 0 do
    mu + sigma * normsinv(p)
  end

  @doc """
  """
  @spec normsinv(p :: float()) :: float()
  def normsinv(p) when p > 0 and p < @low_point do
    # Rational approximation for lower region.
    with q = :math.sqrt(-2 * :math.log(p)) do
      (((((@c1 * q + @c2) * q + @c3) * q + @c4) * q + @c5) * q + @c6) /
        ((((@d1 * q + @d2) * q + @d3) * q + @d4) * q + 1)
    end
  end

  def normsinv(p) when p >= @low_point and p <= @high_point do
    # Rational approximation for central region.
    with q = p - 0.5, r = q * q do
      (((((@a1 * r + @a2) * r + @a3) * r + @a4) * r + @a5) * r + @a6) * q /
        (((((@b1 * r + @b2) * r + @b3) * r + @b4) * r + @b5) * r + 1)
    end
  end

  def normsinv(p) when p > @high_point and p < 1 do
    # Rational approximation for upper region.
    with q = :math.sqrt(-2 * :math.log(1 - p)) do
      -(((((@c1 * q + @c2) * q + @c3) * q + @c4) * q + @c5) * q + @c6) /
        ((((@d1 * q + @d2) * q + @d3) * q + @d4) * q + 1)
    end
  end

  def normsinv(p) when p == 0 or p == 1 do
    0
  end

  def sign(x) when x < 0 do
    -1
  end

  def sign(x) when x == 0 do
    0
  end

  def sign(x) when x > 0 do
    1
  end
end