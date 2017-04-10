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
  I think I need a creator
  """

  @spec create(name :: binary, sv_id :: integer, mean :: integer, std_dev :: number) :: SIPmath.State.t
  def create(name, sv_id, mean, std_dev) when is_binary(name) and is_integer(sv_id) and is_integer(mean) and is_number(std_dev) do
    @default_state
    |> Map.put(:name, name)
    |> Map.put(:sv_id, sv_id)
    |> Map.put(:type_specific, %{@default_state.type_specific | mean: mean, std_dev: std_dev})
  end


  @doc """
  I know I need a next value.

  Calculation is:

  Start variable id = 1
  """
  @spec next_value(state :: SIPmath.State.t) :: State.t_next_value
  def next_value(state = %State{}) do
    with   %{mean: mean, std_dev: std_dev} = state.type_specific,
           sv_id = state.sv_id,
           pm_index = state.pm_index do
      value =
        if std_dev != 0 do
          Math.norminv(
            Math.mod(
              ((Math.mod(:math.pow((sv_id+1_000_000), 2)+(sv_id+1_000_000)*(pm_index+10_000_000), 99_999_989)) + 1_000_007) *
              ((Math.mod(:math.pow((pm_index + 10_000_000), 2) + (pm_index + 10_000_000) * (Math.mod(:math.pow((sv_id + 1_000_000), 2) +
                (sv_id + 1_000_000) * (pm_index + 10_000_000), 99_999_989)), 99_999_989)) + 1_000_013), 2_147_483_647
            ) / 2_147_483_647, mean, std_dev
          )
        else
          mean
        end

      {value, state}
    end
  end

end