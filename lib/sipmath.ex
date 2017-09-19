defmodule SIPmath do
  @moduledoc """
  Documentation for SIPmath.
  """

  @doc """
  Supports the following distributions:

  - Uniform
  - Normal
  - Beta

  ## Examples

      iex> _uniform_dist =
      ...>   with  name ="named dist",
      ...>         seed_value = 1 do
      ...>     SIPmath.Distribution.Uniform.new(seed_value)
      ...>     |> SIPmath.new(name)
      ...>     |> SIPmath.stream()
      ...>     |> Enum.take(1)
      ...>   end
      [0.37674033659358525]

  """

  alias SIPmath.State

  @type t_SIP :: %{
    values: list(number())
  }

  defprotocol SIPable do
    @spec next_value(type_specific_state :: any(), pm_index :: pos_integer()) :: {any(), any()}
    def next_value(type_specific_state, pm_index)
  end

  @spec new(type_specific_state :: any(), name :: String.t()) :: State.t()
  def new(type_specific_state, name) do
    State.new(name, type_specific_state)
  end

  @spec next_value(state :: SIPmath.State.t()) :: State.t_next_value()
  def next_value(state) do
    state.type_specific_state
    |> SIPable.next_value(state.pm_index)
    |> wrap_result_into_state(state)
    |> State.increment_index()
  end

  @spec wrap_result_into_state({value :: any(), type_specific_state :: any()}, state :: SIPmath.State.t()) :: {any(), SIPmath.State.t()}
  defp wrap_result_into_state({value, type_specific_state}, state) do
    {value, %SIPmath.State{state | type_specific_state: type_specific_state}}
  end

  @spec stream(state :: SIPmath.State.t()) :: Enumerable.t()
  def stream(state) do
    state
    |> Stream.unfold(fn state -> next_value(state) end)
  end

  @spec zip_map(states :: list(SIPmath.State.t()), fun :: (any() -> any()), trials :: integer()) :: Enumerable.t()
  def zip_map(states, fun, trials) do
      states
      |> Enum.map(&SIPmath.stream/1)
      |> Stream.zip()
      |> Stream.map(fun)
      |> Enum.take(trials)
  end

# @spec sip_from_list(values :: list(number())) :: t_SIP
  def sip_from_list(values) do
    %{
      values: values
    }
  end
end
