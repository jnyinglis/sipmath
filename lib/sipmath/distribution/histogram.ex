defmodule SIPmath.Distribution.Histogram do
  @moduledoc """
  Generates values by sampling from a supplied histogram.

  The histogram can be given or can be generated from a list of input values.

  """

  alias SIPmath.SIPable
  alias SIPmath.State
  alias SIPmath.Math

  defstruct(
    seed_value: 1,
    histogram: nil,
    samples: nil,
    sample_min: nil,
    sample_max: nil,
    number_of_bins: nil,
    bin_width: nil
  )

  @type t_histogram :: {
          number(),
          pos_integer()
        }

  @type t :: %__MODULE__{
          seed_value: integer(),
          histogram: list(tuple()),
          samples: list(number()),
          sample_min: number(),
          sample_max: number(),
          number_of_bins: integer(),
          bin_width: number()
        }

  @doc """
  """
  @spec new(seed_value :: integer(), histogram :: list(tuple())) :: t()
  def new(seed_value, histogram) do
    %__MODULE__{
      seed_value: seed_value,
      histogram: histogram,
      samples: [1, 2, 3],
      sample_min: 1,
      sample_max: 3,
      number_of_bins: 1,
      bin_width: 1
    }
  end

  @spec histogram(seed_value :: integer(), histogram :: list(tuple()), name :: String.t()) ::
          State.t()
  def histogram(seed_value, histogram, name) do
    new(seed_value, histogram)
    |> SIPmath.new(name)
  end

  defimpl SIPable do
    alias SIPmath.Distribution.Histogram

    @spec next_value(type_specific_state :: Histogram.t(), pm_index :: pos_integer()) ::
            {number(), Histogram.t()}
    def next_value(type_specific_state = %Histogram{}, pm_index) do
      with %{seed_value: seed_value} = type_specific_state do
        value = Math.hdr_uniform(seed_value, pm_index)
        {value, type_specific_state}
      end
    end
  end
end
