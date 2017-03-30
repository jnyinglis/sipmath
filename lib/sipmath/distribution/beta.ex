defmodule SIPmath.Distribution.Beta do
    
  @doc """
  I know I need a next value.

  Calculation is:

  Start variable id = 1
  """
  @spec next_value(state :: SIPmath.State.t) :: {float, SIPmath.State.t}
  def next_value(state) do
    with  alpha = state.alpha,
          beta = state.beta,
          a = state.a,
          b = state.b,
          sv_id = state.sv_id,
          pm_index = state.pm_index do
      0
    end
  end
end