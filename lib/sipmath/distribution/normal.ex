defmodule SIPmath.Distribution.Normal do
  @moduledoc """
  Implementation of Hubbard Decision Research normal number generator
  """

  alias SIPmath.SIPable
  alias SIPmath.Math

  defstruct(
    seed_value: 1,
    mean: 1,
    std_dev: 1
  )

  @type t :: %__MODULE__{
    seed_value: integer(),
    mean: integer(),
    std_dev:  number()
  }

  @doc """
  """
  @spec new(seed_value :: integer(), mean :: integer(), std_dev :: number()) :: t()
  def new(seed_value, mean, std_dev) when is_integer(seed_value) and is_integer(mean) and is_number(std_dev) do
    %__MODULE__{seed_value: seed_value, mean: mean, std_dev: std_dev}
  end


  defimpl SIPable do
    alias SIPmath.Distribution.Normal
    @doc """
    """
    @spec next_value(type_specific_state :: Normal.t(), pm_index :: integer()) :: {number(), Normal.t()}
    def next_value(type_specific_state = %Normal{}, pm_index) do
      with   %{seed_value: seed_value, mean: mean, std_dev: std_dev} = type_specific_state
      do
        value = Math.hdr_normal(mean, std_dev, seed_value, pm_index)
        {value, type_specific_state}
      end
    end
  end
end