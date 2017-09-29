defmodule SIPmath.Distribution.Normal do
  @moduledoc """
  Implementation of Hubbard Decision Research normal number generator
  """

  alias SIPmath.SIPable
  alias SIPmath.State
  alias SIPmath.Math

  defstruct(
    seed_value: 1,
    mean: 0,
    std_dev: 1
  )

  @type t :: %__MODULE__{
    seed_value: integer(),
    mean: number(),
    std_dev:  number()
  }

  @doc """
  Generates numbers based upon the 'bell curve' distribution.
  
  The range of the numbers is dependent upon the values that are supplied for mean and standard deviation.
  """
  @spec new(seed_value :: integer(), mean :: number(), std_dev :: number()) :: t()
  def new(seed_value, mean, std_dev) when is_integer(seed_value) and is_number(mean) and is_number(std_dev) do
    %__MODULE__{seed_value: seed_value, mean: mean, std_dev: std_dev}
  end

  @spec normal(seed_value :: integer(), mean :: number(), std_dev :: number(), name :: String.t()) :: State.t()
  def normal(seed_value, mean, std_dev, name) do
    new(seed_value, mean, std_dev)
    |> SIPmath.new(name)
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