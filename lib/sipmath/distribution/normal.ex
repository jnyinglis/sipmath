defmodule SIPmath.Distribution.Normal do
  @moduledoc """
  Implementation of Hubbard Decision Research normal number generator
  """

  alias SIPmath.State
  alias SIPmath.Math

  @type t_type_specific :: %{
    mean: integer(),
    std_dev:  number()
  }

  @default_state %State{
      type:     __MODULE__,
      name:     nil,
      sv_id:    nil,
      pm_index: 1,
      type_specific:    %{
          mean: nil,
          std_dev: nil
      }
  }

  @doc """
  """

  @spec create(name :: binary, sv_id :: integer, mean :: integer, std_dev :: number) :: SIPmath.State.t
  def create(name, sv_id, mean, std_dev) when is_binary(name) and is_integer(sv_id) and is_integer(mean) and is_number(std_dev) do
    @default_state
    |> Map.put(:name, name)
    |> Map.put(:sv_id, sv_id)
    |> Map.put(:type_specific, %{@default_state.type_specific | mean: mean, std_dev: std_dev})
  end


  @doc """
  """
  @spec next_value(state :: SIPmath.State.t) :: State.t_next_value
  def next_value(state = %State{}) do
    with   %{mean: mean, std_dev: std_dev} = state.type_specific,
           sv_id = state.sv_id,
           pm_index = state.pm_index do

      value = Math.hdr_normal(mean, std_dev, sv_id, pm_index)
      {value, state}
    end
  end

end