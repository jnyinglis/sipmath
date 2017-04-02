defmodule SIPmathTest do
  use ExUnit.Case
  
  alias SIPmath

  doctest SIPmath

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "Uniform HDR: confirm random numbers" do
    uniform_dist = SIPmath.uniform("abc", 1)

    assert [0.37674033659358525] = uniform_dist |> SIPmath.as_stream() |> Enum.take(1)
  end

  test "Uniform HDR: combining random numbers, SIP math" do
    with  uniform_dist_1 = SIPmath.uniform("value1", 1),
          uniform_dist_2 = SIPmath.uniform("value2", 2),
          outcome_fun = fn {value1, value2} -> value1 + value2 end,
          trials = 1
    do
      assert [0.8014632555662948] = [uniform_dist_1, uniform_dist_2] |> SIPmath.apply_function(outcome_fun, trials)
    end
  end

  test "Normal HDR: confirm first random number" do
    normal_dist = 
      with  sv_id = 2,
            mean = 4,
            std_dev = 12, do: SIPmath.normal("abc", sv_id, mean, std_dev)

    assert [1.7220934633775773] = normal_dist |> SIPmath.as_stream() |> Enum.take(1)
  end

  test "Beta HDR: confirm first random number" do
    beta_dist = 
      with  sv_id = 1,
            alpha = 4,
            beta = 10,
            a = 1,
            b = 3, do: SIPmath.beta("abc", sv_id, alpha, beta, a, b )

    assert [1.46715] = beta_dist |> SIPmath.as_stream() |> Enum.take(1)
  end
end
