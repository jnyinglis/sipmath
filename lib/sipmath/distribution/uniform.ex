defmodule SIPmath.Distribution.Uniform do
  @moduledoc """
  Implementation of Hubbard Decision Research uniform number generator
  """

  alias SIPmath.State

  @state %State{
      type:     __MODULE__,
      name:     nil,
      sv_id:    nil,
      pm_index: 1
  }

  @doc """
  I think I need a creator
  """

  @spec create(name :: String.t, sv_id :: integer) :: SIPmath.State.t
  def create(name, sv_id) do
    @state
    |> Map.put(:name, name)
    |> Map.put(:sv_id, sv_id)
  end

  @doc """
  I know I need a next value.

  Calculation is:

  Start variable id = 1
  """
  @spec next_value(state :: SIPmath.State.t) :: {float, SIPmath.State.t}
  def next_value(state) do
    with   sv_id = state.sv_id,
           pm_index = state.pm_index do
      value =
        rem(
          round(
            (
              (
                rem(
                  round(
                        :math.pow((sv_id + 1000000), 2) + (sv_id + 1000000) * (pm_index + 10000000)
                  ), 99999989
                )
              ) + 1000007
            )
            *
            (
              (
                rem(
                  round(
                    :math.pow((pm_index + 10000000), 2) + (pm_index + 10000000) *
                    (rem(round(:math.pow((sv_id + 1000000), 2) + (sv_id + 1000000) * (pm_index + 10000000)), 99999989 ))
                  ), 99999989
                )
              ) + 1000013
            )
          ), 2147483647
        ) / 2147483647
        
      {value, state}
    end
  end

  @doc """
  I think I need an initialize
  """
  defp initialize do

  end

end