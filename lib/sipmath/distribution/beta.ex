defmodule SIPmath.Distribution.Beta do
  @moduledoc """
  Implementation of Hubbard Decision Research uniform number generator
  """

  alias SIPmath.SIPable
  alias SIPmath.Math
 
  defstruct(
    seed_value: 1,
    alpha:  4,
    beta:   10,
    a:      1,
    b:      3
  )

  @type t :: %__MODULE__{
    seed_value: pos_integer(),
    alpha:  number(),
    beta:   number(),
    a:      number(),
    b:      number()
  }

  @spec new(seed_value :: integer(), alpha :: number(), beta :: number(), a :: number(), b :: number()) :: t()
  def new(seed_value, alpha, beta, a, b) when is_integer(seed_value) and is_number(alpha) and is_number(beta) do
    %__MODULE__{seed_value: seed_value, alpha: alpha, beta: beta, a: a, b: b}
  end

  defimpl SIPable do
    alias SIPmath.Distribution.Beta
    @doc """
    """
    @spec next_value(type_specific_state :: Beta.t(), pm_index :: integer()) :: {number(), Beta.t()}
    def next_value(type_specific_state = %Beta{}, pm_index) do
      with  %{seed_value: seed_value, alpha: alpha, beta: beta, a: a, b: b} = type_specific_state
      do
        value = Math.mod(alpha + beta + a + b + seed_value, pm_index)
        {value, type_specific_state}
      end
    end
  end
end