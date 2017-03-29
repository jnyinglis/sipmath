defmodule SIPmathTest do
  use ExUnit.Case
  
  alias SIPmath.Uniform
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
end
