defmodule SIPmathTest do
  use ExUnit.Case
  
  alias SIPmath.Uniform

  doctest SIPmath

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "Uniform HDR: confirm random numbers" do
    sv_id = 1
    pm_index = 1
    assert Uniform.next_value(sv_id, pm_index) == 0.37674033659358525
  end
end
