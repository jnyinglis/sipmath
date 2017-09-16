defmodule SIPmath.Distribution.Uniform do
  @moduledoc """
  Implementation of Hubbard Decision Research uniform number generator
  """

  alias SIPmath.State
  alias SIPmath.Math

  @type t_type_specific ::  %{
    min: number(),
    max: number()
  }

  @default_state %State{
    type:     __MODULE__,
    name:     nil,
    sv_id:    nil,
    pm_index: 1,
    type_specific: %{
      min: 0,
      max: 1
    }
  }

  @doc """
  """

  @spec create(name :: String.t, sv_id :: integer()) :: SIPmath.State.t
  def create(name, sv_id) when is_binary(name) and is_integer(sv_id) do
    @default_state
    |> Map.put(:name, name)
    |> Map.put(:sv_id, sv_id)
  end

  @spec create(name :: String.t, sv_id :: integer(), min :: number(), max :: number()) :: SIPmath.State.t
  def create(name, sv_id, min, max) when is_binary(name) and is_integer(sv_id) and is_number(min) and is_number(max) do
    @default_state
    |> Map.put(:name, name)
    |> Map.put(:sv_id, sv_id)
    |> Map.put(:type_specific, %{@default_state.type_specific | min: min, max: max})
  end

  @doc """
  """
  @spec next_value(state :: SIPmath.State.t) :: State.t_next_value
  def next_value(state = %State{}) do
    with %{min: min, max: max} = state.type_specific,
         sv_id = state.sv_id,
         pm_index = state.pm_index
    do

      rnd_value = Math.hdr_uniform(sv_id, pm_index)
      value = (max  * rnd_value) + min
      {value, state}
    end
  end

end