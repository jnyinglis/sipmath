defmodule SIPmathTest do
  use ExUnit.Case
  
  alias SIPmath
  alias SIPmath.State

  doctest SIPmath

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "Uniform HDR: confirm random numbers" do
    abc = SIPmath.uniform("abc", 1)

    assert [0.37674033659358525] = abc |> SIPmath.as_stream() |> Enum.take(1)
  end

  test "Beta HDR: confirm first random number" do
    state =
      %State{}
      |> Map.put(:alpha, 4)
      |> Map.put(:beta, 10)
      |> Map.put(:a, 1)
      |> Map.put(:b, 3)
      |> Map.put(:sv_id, 1)
      |> Map.put(:pm_index, 1)

    assert {1.46715, _state} = Beta.next_value(state)
  end
end
