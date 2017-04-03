defmodule Actual do
    @moduledoc """
    Implement generating a stream of values using historical values.
    """

  alias SIPmath.State
  alias SIPmath.Math
 
  @type t_type_specific :: %{
    actuals:  list(number()),
    unused: list(number()),
    next_value: number()
  }

  @default_state %State{
      type:     __MODULE__,
      name:     nil,
      sv_id:    nil,
      pm_index: 1,
      type_specific:  %{
        actuals:  nil,
        unused: nil,
        next_value: nil
      }
  }
   
  @spec create(name :: String.t, sv_id :: integer(), actuals :: list(number())) :: SIPmath.State.t
  def create(name, sv_id, actuals) when is_integer(sv_id) and is_list(actuals) do
    @default_state
    |> Map.put(:name, name)
    |> Map.put(:sv_id, sv_id)
    |> Map.put(:type_specific, %{actuals: actuals, unused: actuals})
  end

  @doc """
  I know I need a next value.

  Calculation is:

  Start variable id = 1
  """
  @spec next_value(state :: SIPmath.State.t) :: State.t_next_value
  def next_value(state = %State{}) do
    with  %{actuals: actuals, unused: unused} = state.type_specific,
          sv_id = state.sv_id,
          pm_index = state.pm_index
    do
      _ = [value | tail] = unused
      next_unused =
        case tail do
            [] -> actuals
            true -> tail
        end

      {value, %{state | type_specific: %{state.type_specific | unused: next_unused}}}
    end
  end
end