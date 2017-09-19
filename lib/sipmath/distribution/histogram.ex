defmodule SIPmath.Distribution.Histogram do
  @moduledoc """
  Generates values by sampling from a supplied histogram.

  The histogram can be given or can be generated from a list of input values.

  """

  defstruct(
    histogram:      nil,
    samples:        nil,
    sample_min:     nil,
    sample_max:     nil,
    number_of_bins: nil,
    bin_width:      nil
  )

  @type t_histogram :: {
    number(),
    pos_integer()
  }

  @type t :: %__MODULE__{
    histogram:      tuple(),
    samples:        list(number()),
    sample_min:     number(),
    sample_max:     number(),
    number_of_bins: integer(),
    bin_width:      number()
  }

  @doc """
  """
  @spec new(seed_value :: integer()) :: t()
  def new(seed_value) when is_integer(seed_value) do
    %__MODULE__{histogram: {1, 2}, samples: [1,2,3], sample_min: 1, sample_max: 3, number_of_bins: 1, bin_width: 1}
  end
end