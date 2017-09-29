defmodule SIPmath.Distribution.Uniform do
  @moduledoc """
  Implementation of Hubbard Decision Research uniform number generator
  """

  alias SIPmath.SIPable
  alias SIPmath.State
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
  Generates numbers between 0 and 1 (standard uniform distribution), where each value is equally probable.
  """

  @spec new(seed_value :: pos_integer()) :: t()
  def new(seed_value) when is_integer(seed_value) do
    new(seed_value, 0, 1)
  end
  @spec new(seed_value :: pos_integer(), min :: number(), max :: number()) :: t()
  def new(seed_value, min, max) when is_integer(seed_value) and is_number(min) and is_number(max) do
    %__MODULE__{seed_value: seed_value, min: min, max: max}
  end

  @spec uniform(seed_value :: pos_integer(), name :: String.t()) :: State.t()
  def uniform(seed_value, name) do
    new(seed_value)
    |> SIPmath.new(name)
  end
  @spec uniform(seed_value :: pos_integer(), min :: number(), max :: number(), name :: String.t()) :: State.t()
  def uniform(seed_value, min, max, name) do
    new(seed_value, min, max)
    |> SIPmath.new(name)
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