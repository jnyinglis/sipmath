defmodule SIPmath.Distribution.Cycle do
  @moduledoc """
  Implement generating a stream of values by cycling through the values that were supplied.
  This can be useful for repeating a constant value or rotating through a short sequences of values.
  """

  alias SIPmath.SIPable
 
  defstruct(
    cycle_values:  nil,
    unused_values: nil
  )

  @type t :: %__MODULE__{
    cycle_values:  nonempty_list(any()),
    unused_values: nonempty_list(any())
  }

  @spec new(cycle_values :: nonempty_list(number())) :: t()
  def new(cycle_values = [_h | _t]) when is_list(cycle_values) do
    %__MODULE__{cycle_values: cycle_values, unused_values: cycle_values}
  end

  defimpl SIPable do
    alias SIPmath.Distribution.Cycle

    @doc """
    """
    @spec next_value(type_specific_state :: Cycle.t(), pm_index :: integer()) :: {any(), Cycle.t()}
    def next_value(type_specific_state = %Cycle{}, _pm_index) do
      with  %{cycle_values: cycle_values, unused_values: unused_values} = type_specific_state
      do
        [value | new_unused_values] =
          case unused_values do
            [h | []] -> [h | cycle_values]
            [h | t] -> [h | t]
          end

        new_type_specific_state = %{type_specific_state | unused_values: new_unused_values}
        {value, new_type_specific_state}
      end
    end
  end
end