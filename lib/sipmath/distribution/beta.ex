defmodule SIPmath.Distribution.Beta do
  @moduledoc """
  Implementation of Hubbard Decision Research uniform number generator
  """

  alias SIPmath.State
 
  @default_state %State{
      type:     __MODULE__,
      name:     nil,
      sv_id:    nil,
      pm_index: 1,
      type_specific:  %{
        alpha:  4,
        beta:   10,
        a:      1,
        b:      3
      }
  }
   
  @spec create(name :: String.t, sv_id :: integer, alpha :: integer, beta :: integer, a :: integer, b :: integer) :: SIPmath.State.t
  def create(name, sv_id, alpha, beta, a, b) do
    @default_state
    |> Map.put(:name, name)
    |> Map.put(:sv_id, sv_id)
    |> Map.put(:type_specific, %{alpha: alpha, beta: beta, a: a, b: b})
  end

  @doc """
  I know I need a next value.

  Calculation is:

  Start variable id = 1
  """
  @spec next_value(state :: SIPmath.State.t) :: State.t_next_value
  def next_value(state) do
    with  %{alpha: _alpha, beta: _beta, a: _a, b: _b} = state.type_specific,
          _sv_id = state.sv_id,
          _pm_index = state.pm_index do
      {0, state}
    end
  end
end