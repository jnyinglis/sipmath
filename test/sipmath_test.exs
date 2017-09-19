defmodule SIPmathTest do
  use ExUnit.Case
  
  alias SIPmath

  doctest SIPmath

  test "#0 - the truth" do
    assert 1 + 1 == 2
  end

  test "#1 - Uniform HDR: confirm random numbers" do
    uniform_dist = SIPmath.Distribution.Uniform.new(1) |> SIPmath.new("x")

    assert [0.37674033659358525] == uniform_dist |> SIPmath.stream() |> Enum.take(1)
  end

  test "#2 - Uniform HDR: confirm random numbers between 1 and 6" do
    with min = 1,
         max = 6,
         seed_value = 1,
         uniform_dist = SIPmath.Distribution.Uniform.new(seed_value, min, max) |> SIPmath.new("x")
    do
        assert [3, 6, 4, 5, 2, 5, 6, 5, 1, 4, 1, 1] == uniform_dist |> SIPmath.stream() |> Enum.take(12) |> Enum.map(fn x -> trunc(x) end) # |> Enum.reduce(%{}, fn(x, acc) -> Map.put(acc, x, Map.get(acc, x, 0) + 1) end)
    end

  end


  test "#3 - Uniform HDR: combining random numbers, SIP math" do
    with  uniform_dist_1 = SIPmath.Distribution.Uniform.new(1) |> SIPmath.new("value1"),
          uniform_dist_2 = SIPmath.Distribution.Uniform.new(2) |> SIPmath.new("value2"),
          outcome_fun = fn {value1, value2} -> value1 + value2 end,
          trials = 1
    do
      assert [0.8014632555662948] = [uniform_dist_1, uniform_dist_2] |> SIPmath.zip_map(outcome_fun, trials)
    end
  end

  test "#4 - Normal HDR: confirm first random number" do
    with  seed_value = 2,
          mean = 4,
          std_dev = 12,
          normal_dist = SIPmath.Distribution.Normal.new(seed_value, mean, std_dev) |> SIPmath.new("x")
    do
      assert [1.7220934633775773] = normal_dist |> SIPmath.stream() |> Enum.take(1)
    end
  end

# test "#5 - Beta HDR: confirm first random number" do
#   with  seed_value = 1,
#         alpha = 4,
#         beta = 10,
#         a = 1,
#         b = 3,
#         beta_dist = SIPmath.beta("x", seed_value, alpha, beta, a, b )
#   do
#     assert [1.46715] = beta_dist |> SIPmath.stream() |> Enum.take(1)
#   end
# end

  test "#6 - SIPmath.cycle: Teexst that cycle returns the given values as a stream, and repeats when the requested output is longer than the input" do
    historical_demand = [5, 6, 10, 8, 7, 10, 5, 5, 3, 2, 6, 5, 6, 3, 5, 4, 5, 4, 4, 3, 3, 3, 4, 3, 8, 3, 5, 2, 4, 5, 7, 6, 7, 8, 1, 5]

    with  cycle_dist = SIPmath.Distribution.Cycle.new(historical_demand) |> SIPmath.new("x")
    do
      test_historical_demand = historical_demand ++ historical_demand
      assert test_historical_demand == cycle_dist |> SIPmath.stream() |> Enum.take(Enum.count(test_historical_demand))
    end
  end

  test "#7 - SIPmath.cycle: Test Beyond Budget" do
    historical_demand = [5, 6, 10, 8, 7, 10, 5, 5, 3, 2, 6, 5, 6, 3, 5, 4, 5, 4, 4, 3, 3, 3, 4, 3, 8, 3, 5, 2, 4, 5, 7, 6, 7, 8, 1, 5]
    cost = [0, 150, 750, 450, 300, 750, 0, 0, 100, 150, 150, 0, 150, 100, 0, 50, 0, 50, 50, 100, 100, 100, 50, 100, 450, 100, 0, 150, 50, 0, 300, 150, 300, 450, 200, 0]
    cycle_dist = fn list, name -> SIPmath.Distribution.Cycle.new(list) |> SIPmath.new(name) end
    with  demand_dist = cycle_dist.(historical_demand, "demand"),
          amt_stocked_dist = cycle_dist.([5], "stocked"),
          expiration_dist = cycle_dist.([50], "expiration"),
          airfreight_dist = cycle_dist.([150], "airfreight"),
          outcome_fun = fn {demand, stocked, expiration, airfreight} ->
            case (stocked-demand) do
              overstocked when overstocked > 0 -> overstocked * expiration
              understocked when understocked < 0 -> -(understocked) * airfreight
              0 -> 0
            end
          end,
          trials = Enum.count(historical_demand)
    do
      assert cost == [demand_dist, amt_stocked_dist, expiration_dist, airfreight_dist] |> SIPmath.zip_map(outcome_fun, trials)
    end
  end

  test "#8 - SIPmath.cycle/1: Fail when an empty list or no values are supplied" do
    empty_list = []

    assert_raise FunctionClauseError, fn ->
      SIPmath.Distribution.Cycle.new(empty_list)
    end

    assert_raise FunctionClauseError, fn ->
      SIPmath.Distribution.Cycle.new(nil)
    end
  end

  test "#9 - SIPmath.sequence/2" do
    with  start_value = 1,
          step_value = 1,
          sequence_dist = SIPmath.Distribution.Sequence.new(start_value, step_value) |> SIPmath.new("sequence")
    do
      assert [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] == sequence_dist |> SIPmath.stream() |> Enum.take(10)
    end
  end

  test "#10 - SIPmath.sip_from_list/1" do
    input_values = 1..100

    output_list =
      1..100
      |> SIPmath.sip_from_list()

    assert %{ values: input_values } == output_list
  end
end
