defmodule SIPmath.Distribution.Sequence do
  @moduledoc """
  Implement generating a stream of values where succesive values follow a predetermined sequence.
  An example of this is monotonically increasing values.
  """

  alias SIPmath.SIPable

  defstruct(
    start_value: 1,
    step_value: 1,
    last_value: nil
  )

  @type t :: %__MODULE__{
    start_value:  integer(),
    step_value: integer(),
    last_value: (nil | integer())
  }

  @spec new(start_value :: integer(), step_value :: integer()) :: t()
  def new(start_value, step_value) when is_integer(start_value) and is_integer(step_value) do
    %__MODULE__{start_value: start_value, step_value: step_value, last_value: nil}
  end

  defimpl SIPable do
    alias SIPmath.Distribution.Sequence
    @doc """
    """
    @spec next_value(type_specific_state :: Sequence.t(), _pm_index :: integer()) :: {integer(), Sequence.t()}
    def next_value(type_specific_state = %Sequence{}, _pm_index) do
      with  %{start_value: start_value, step_value: step_value, last_value: last_value} = type_specific_state
      do
        value = 
          case last_value do
            nil -> start_value
            _x -> last_value + step_value
          end
  
        new_type_specific_state = %{type_specific_state | last_value: value}
        {value, new_type_specific_state}
      end
    end
  end
end