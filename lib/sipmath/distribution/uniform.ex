defmodule SIPmath.Distribution.Uniform do
  @moduledoc """
  Implementation of Hubbard Decision Research uniform number generator
  """

  alias SIPmath.SIPable
  alias SIPmath.Math

  defstruct(
    seed_value: 1,
    min: 0,
    max: 1
  )

  @type t :: %__MODULE__{
    seed_value: pos_integer(),
    min: number(),
    max: number()
  }

  @doc """
  """

  @spec new(seed_value :: pos_integer()) :: t()
  def new(seed_value) when is_integer(seed_value) do
    new(seed_value, 0, 1)
  end
  @spec new(seed_value :: pos_integer(), min :: number(), max :: number()) :: t()
  def new(seed_value, min, max) when is_integer(seed_value) and is_number(min) and is_number(max) do
    %__MODULE__{seed_value: seed_value, min: min, max: max}
  end

  defimpl SIPable do
    alias SIPmath.Distribution.Uniform

    @spec next_value(type_specific_state :: Uniform.t(), pm_index :: pos_integer()) :: {number(), Uniform.t()}
    def next_value(type_specific_state = %Uniform{}, pm_index) do
      with %{seed_value: seed_value, min: min, max: max} = type_specific_state
      do
  
        rnd_value = Math.hdr_uniform(seed_value, pm_index)
        value = (max  * rnd_value) + min
        {value, type_specific_state}
      end
    end
  end
end