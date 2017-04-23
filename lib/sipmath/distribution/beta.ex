defmodule SIPmath.Distribution.Beta do
  @moduledoc """
  Implementation of Hubbard Decision Research uniform number generator
  """

  alias SIPmath.State
  alias SIPmath.Math
 
  @type t_type_specific :: %{
    alpha:  number(),
    beta:   number(),
    a:      number(),
    b:      number()
  }

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
   
  @spec create(name :: String.t, sv_id :: integer(), alpha :: number(), beta :: number(), a :: number(), b :: number()) :: SIPmath.State.t
  def create(name, sv_id, alpha, beta, a, b) when is_integer(sv_id) and is_number(alpha) and is_number(beta) do
    @default_state
    |> Map.put(:name, name)
    |> Map.put(:sv_id, sv_id)
    |> Map.put(:type_specific, %{alpha: alpha, beta: beta, a: a, b: b})
  end

  @doc """
  """
  @spec next_value(state :: SIPmath.State.t) :: State.t_next_value
  def next_value(state = %State{}) do
    with  %{alpha: alpha, beta: beta, a: a, b: b} = state.type_specific,
          sv_id = state.sv_id,
          pm_index = state.pm_index
    do
      value = Math.mod(alpha + beta + a + b + sv_id, pm_index)
      {value, state}
    end
  end
end