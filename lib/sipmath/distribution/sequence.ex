defmodule Sequence do
  @moduledoc """
  Implement generating a stream of values where succesive values follow a predetermined sequence.
  An example of this is monotonically increasing values.
  """

  alias SIPmath.State
 
  @type t_type_specific :: %{
    start_value:  integer(),
    step_value: integer(),
    last_value: integer()
  }

  @default_state %State{
      type:     __MODULE__,
      name:     nil,
      sv_id:    nil,
      pm_index: 1,
      type_specific:  %{
        start_value:  nil,
        step_value: nil,
        last_value: nil
      }
  }
   
  @spec create(name :: String.t, sv_id :: integer(), start_value :: integer(), step_value :: integer()) :: SIPmath.State.t
  def create(name, sv_id, start_value, step_value) when is_integer(sv_id) and is_integer(start_value) and is_integer(step_value) do
    #
    # N.B.
    # Using the style below ('Map.put') needs to be addressed for type_specific,
    # because the default values are not preserved
    #
    @default_state
    |> Map.put(:name, name)
    |> Map.put(:sv_id, sv_id)
    |> Map.put(:type_specific, %{@default_state.type_specific | start_value: start_value, step_value: step_value})
  end

  @doc """
  I know I need a next value.

  Calculation is:

  Start variable id = 1
  """
  @spec next_value(state :: SIPmath.State.t) :: State.t_next_value
  def next_value(state = %State{}) do
    with  %{start_value: start_value, step_value: step_value, last_value: last_value} = state.type_specific,
          _sv_id = state.sv_id,
          _pm_index = state.pm_index
    do
      value =
        case last_value do
          nil -> start_value
          _x -> last_value + step_value
        end

      new_type_specific = %{state.type_specific | last_value: value}
      {value, %{state | type_specific: new_type_specific}}
    end
  end
end