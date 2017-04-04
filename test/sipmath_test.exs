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
      assert [0.8014632555662948] = [uniform_dist_1, uniform_dist_2] |> SIPmath.apply_function_to_list(outcome_fun, trials)
    end
  end

  test "Normal HDR: confirm first random number" do
    with  sv_id = 2,
          mean = 4,
          std_dev = 12,
          normal_dist = SIPmath.normal("abc", sv_id, mean, std_dev)
    do
      assert [1.7220934633775773] = normal_dist |> SIPmath.as_stream() |> Enum.take(1)
    end
  end

  test "Beta HDR: confirm first random number" do
    with  sv_id = 1,
          alpha = 4,
          beta = 10,
          a = 1,
          b = 3,
          beta_dist = SIPmath.beta("abc", sv_id, alpha, beta, a, b )
    do
      assert [1.46715] = beta_dist |> SIPmath.as_stream() |> Enum.take(1)
    end
  end

  test "SIPmath.actual/3 Test that actual values are returned as a stream, which is longer than input" do
    historical_demand = [5, 6, 10, 8, 7, 10, 5, 5, 3, 2, 6, 5, 6, 3, 5, 4, 5, 4, 4, 3, 3, 3, 4, 3, 8, 3, 5, 2, 4, 5, 7, 6, 7, 8, 1, 5]

    with  sv_id = 1,
          actual_dist = SIPmath.actual("abc", sv_id, historical_demand)
    do
      test_historical_demand = historical_demand ++ historical_demand
      assert test_historical_demand == actual_dist |> SIPmath.as_stream() |> Enum.take(Enum.count(test_historical_demand))
    end
  end

  test "SIPmath.actual/3 Test Beyond Budget" do
    historical_demand = [5, 6, 10, 8, 7, 10, 5, 5, 3, 2, 6, 5, 6, 3, 5, 4, 5, 4, 4, 3, 3, 3, 4, 3, 8, 3, 5, 2, 4, 5, 7, 6, 7, 8, 1, 5]
    cost = [0, 150, 750, 450, 300, 750, 0, 0, 100, 150, 150, 0, 150, 100, 0, 50, 0, 50, 50, 100, 100, 100, 50, 100, 450, 100, 0, 150, 50, 0, 300, 150, 300, 450, 200, 0]
    with  sv_id = 1,
          demand_dist = SIPmath.actual("demand", sv_id, historical_demand),
          amt_stocked_dist = SIPmath.actual("stocked", sv_id, [5]),
          expiration_dist = SIPmath.actual("stocked", sv_id, [50]),
          airfreight_dist = SIPmath.actual("airfreight", sv_id, [150]),
          outcome_fun = fn {demand, stocked, expiration, airfreight} ->
            case (stocked-demand) do
              overstocked when overstocked > 0 -> overstocked * expiration
              understocked when understocked < 0 -> -(understocked) * airfreight
              0 -> 0
            end
          end,
          trials = Enum.count(historical_demand)
    do
      assert cost == [demand_dist, amt_stocked_dist, expiration_dist, airfreight_dist] |> SIPmath.apply_function_to_list(outcome_fun, trials)
    end
  end

  test "SIPmath.actual/3 Fail when an empty list or no values are supplied" do
    empty_list = []
    sv_id = 1

    assert_raise FunctionClauseError, fn ->
      SIPmath.actual("ab", sv_id, empty_list)
    end

    assert_raise FunctionClauseError, fn ->
      SIPmath.actual("ab", sv_id, nil)
    end
  end
end
