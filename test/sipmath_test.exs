defmodule SIPmathTest do
  use ExUnit.Case
  
  alias SIPmath.Distribution.Uniform
  alias SIPmath.Distribution.Beta

  doctest SIPmath

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "Uniform HDR: confirm first random number" do
    sv_id = 1
    pm_index = 1
    assert Uniform.next_value(sv_id, pm_index) == 0.37674033659358525
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
