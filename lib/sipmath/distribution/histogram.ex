defmodule SIPmath.Distribution.Histogram do
  @moduledoc """
  Generates values by sampling from a supplied histogram.

  The histogram can be given or can be generated from a list of input values.

  """

  alias SIPmath.State

  @type t_histogram :: {
    number(),
    pos_integer()
  }

  @type t_type_specific :: %{
    histogram:      tuple(),
    samples:        list(number()),
    sample_min:     number(),
    sample_max:     number(),
    number_of_bins: integer(),
    bin_width:      number()
  }

  @default_state %State{
      type:     __MODULE__,
      name:     nil,
      sv_id:    nil,
      pm_index: 1,
      type_specific:    nil
  }

  @doc """
  I think I need a creator
  """

  @spec create(name :: binary, sv_id :: integer ) :: SIPmath.State.t
  def create(name, sv_id) when is_binary(name) and is_integer(sv_id) do
    @default_state
    |> Map.put(:name, name)
    |> Map.put(:sv_id, sv_id)
    |> Map.put(:type_specific, nil)
  end
end