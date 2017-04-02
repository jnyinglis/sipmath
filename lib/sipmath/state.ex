defmodule SIPmath.State do
    
  @moduledoc false

  alias SIPmath.Distribution.{Uniform, Normal, Beta}

  defstruct(
    type:       __MODULE__,
    name:       nil,
    sv_id:      nil,
    pm_index:   nil,
    type_specific:  nil
  )

  @type t :: %__MODULE__{
    type: any,
    name: String.t,
    sv_id:  integer,
    pm_index: integer,
    type_specific:  Uniform.t_type_specific |  Normal.t_type_specific | Beta.t_type_specific
  }

  @type t_next_value :: {float, SIPmath.State.t}

  @spec increment_index(next_value :: t_next_value) :: t_next_value
  def increment_index(_next_value = {value, state = %SIPmath.State{}}) do
    {value, %SIPmath.State{state | pm_index: state.pm_index + 1}}
  end

end