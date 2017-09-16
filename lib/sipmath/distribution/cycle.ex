defmodule SIPmath.Distribution.Cycle do
  @moduledoc """
  Implement generating a stream of values by cycling through the values that were supplied.
  This can be useful for repeating a constant value or rotating through a short sequences of values.
  """

  alias SIPmath.State
 
  @type t_type_specific :: %{
    cycle_values:  nonempty_list(number),
    unused_values: nonempty_list(number)
  }

  @default_state %State{
      type:     __MODULE__,
      name:     nil,
      sv_id:    nil,
      pm_index: 1,
      type_specific:  %{
        cycle_values:  nil,
        unused_values: nil
      }
  }
   
  @spec create(name :: String.t, sv_id :: integer(), cycle_values :: nonempty_list(number())) :: SIPmath.State.t
  def create(name, sv_id, cycle_values = [_h | _t]) when is_integer(sv_id) and is_list(cycle_values) do
    @default_state
    |> Map.put(:name, name)
    |> Map.put(:sv_id, sv_id)
    |> Map.put(:type_specific, %{cycle_values: cycle_values, unused_values: cycle_values})
  end

  @doc """
  I know I need a next value.

  Calculation is:

  Start variable id = 1
  """
  @spec next_value(state :: SIPmath.State.t) :: State.t_next_value
  def next_value(state = %State{}) do
    with  %{cycle_values: cycle_values, unused_values: unused_values} = state.type_specific,
          _sv_id = state.sv_id,
          _pm_index = state.pm_index
    do
      [value | new_unused_values] =
        case unused_values do
          [h | []] -> [h | cycle_values]
          [h | t] -> [h | t]
        end

      new_type_specific = %{state.type_specific | unused_values: new_unused_values}
      {value, %{state | type_specific: new_type_specific}}
    end
  end
end