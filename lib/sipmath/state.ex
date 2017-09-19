defmodule SIPmath.State do
    
  @moduledoc false

  defstruct(
    type:       __MODULE__,
    name:       nil,
    pm_index:   nil,
    type_specific_state:  nil
  )

  @type t :: %__MODULE__{
    type: any(),
    name: String.t,
    pm_index: integer(),
    type_specific_state: any()
  }

  @type t_next_value :: {any(), t()}

  @spec new(name :: String.t(), type_specific_state :: any()) :: t()
  def new(name, type_specific_state) do
    %__MODULE__{name: name, pm_index: 1, type_specific_state: type_specific_state}
  end

  @spec increment_index(next_value :: t_next_value()) :: t_next_value()
  def increment_index({value, state = %SIPmath.State{}}) do
    {value, %SIPmath.State{state | pm_index: state.pm_index + 1}}
  end

end