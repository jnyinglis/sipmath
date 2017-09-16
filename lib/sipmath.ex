defmodule SIPmath do
  @moduledoc """
  Documentation for SIPmath.
  http://probabilitymanagement.org/index.html
  """

  @doc """
  Supports the following distributions:

  - Uniform
  - Normal
  - Beta

  ## Examples

      iex> _uniform_dist =
      ...>   with  name ="named dist",
      ...>         sv_id = 1 do
      ...>     SIPmath.uniform(name, sv_id)
      ...>     |> SIPmath.stream()
      ...>     |> Enum.take(1)
      ...>   end
      [0.37674033659358525]

  """

  alias SIPmath.Distribution.{Uniform, Beta, Normal, Cycle}
  alias SIPmath.State

  @type t_SIP :: %{
    values: list(number())
  }

  @spec uniform(name :: String.t, sv_id :: integer()) :: SIPmath.State.t
  def uniform(name, sv_id) do
    Uniform.create(name, sv_id)
  end

  @spec uniform(name :: String.t, sv_id :: integer(), min :: integer(), max:: integer()) :: SIPmath.State.t
  def uniform(name, sv_id, min, max) do
    Uniform.create(name, sv_id, min, max)
  end

  @spec normal(name :: String.t, sv_id :: integer(), mean :: integer(), std_dev :: number()) :: SIPmath.State.t
  def normal(name, sv_id, mean, std_dev) do
    Normal.create(name, sv_id, mean, std_dev)
  end

  @spec beta(name :: String.t, sv_id :: integer(), alpha :: integer(), beta :: integer(), a :: integer, b:: integer) :: SIPmath.State.t
  def beta(name, sv_id, alpha, beta, a, b) do
    Beta.create(name, sv_id, alpha, beta, a, b)
  end

  @spec cycle(name :: String.t, sv_id :: integer(), cycle_values :: nonempty_list(number())) :: SIPmath.State.t
  def cycle(name, sv_id, cycle_values = [_h | _t]) do
    Cycle.create(name, sv_id, cycle_values)
  end

  @spec sequence(name :: String.t, sv_id :: integer(), start_value :: integer(), step_value :: integer()) :: SIPmath.State.t
  def sequence(name, sv_id, start_value, step_value) do
    Sequence.create(name, sv_id, start_value, step_value)
  end

  @spec next_value(state :: SIPmath.State.t) :: State.t_next_value
  def next_value(state) do
    state
    |> state.type.next_value()
    |> State.increment_index()
  end

  @spec stream(state :: SIPmath.State.t) :: Enumerable.t
  def stream(state) do
    state
    |> Stream.unfold(fn state -> next_value(state) end)
  end

  @spec zip_map(states :: list(SIPmath.State.t), fun :: (any -> any), trials :: integer()) :: Enumerable.t
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
