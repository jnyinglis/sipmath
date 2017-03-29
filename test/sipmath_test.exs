defmodule SIPmathTest do
  use ExUnit.Case
  
  alias SIPmath.Distribution.Uniform
  alias SIPmath.Distribution.Beta
  alias SIPmath.State

  doctest SIPmath

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "Uniform HDR: confirm random numbers" do
    state =
      %State{}
      |> Map.put(:sv_id, 1)
      |> Map.put(:pm_index, 1)

    assert {0.37674033659358525, _state} = Uniform.next_value(state)
  end

  test "Beta HDR: confirm first random number" do
    alpha = 4
    beta = 10
    a = 1
    b = 3
    sv_id = 1
    pm_index = 1
    assert Beta.next_value(alpha, beta, a, b, sv_id, pm_index) == 1.46715
  end
end
