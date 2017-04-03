defmodule SIPmath do
  @moduledoc """
  Documentation for Sipmath.
  """

  @doc """
  Supports the following distributions:

  Uniform
  Normal
  Beta

  ## Examples

      iex> _uniform_dist =
      ...>   with  name ="named dist",
      ...>         sv_id = 1 do
      ...>     SIPmath.uniform(name, sv_id)
      ...>     |> SIPmath.as_stream()
      ...>     |> Enum.take(1)
      ...>   end
      [0.37674033659358525]

  """

  alias SIPmath.Distribution.{Uniform, Beta, Normal, Actual}
  alias SIPmath.State

  @spec uniform(name :: String.t, sv_id :: integer()) :: SIPmath.State.t
  def uniform(name, sv_id) do
    Uniform.create(name, sv_id)
  end

  @spec normal(name :: String.t, sv_id :: integer(), mean :: integer(), std_dev :: number()) :: SIPmath.State.t
  def normal(name, sv_id, mean, std_dev) do
    Normal.create(name, sv_id, mean, std_dev)
  end

  @spec beta(name :: String.t, sv_id :: integer(), alpha :: integer(), beta :: integer(), a :: integer, b:: integer) :: SIPmath.State.t
  def beta(name, sv_id, alpha, beta, a, b) do
    Beta.create(name, sv_id, alpha, beta, a, b)
  end

  @spec actual(name :: String.t, sv_id :: integer(), actuals :: nonempty_list(number())) :: SIPmath.State.t
  def actual(name, sv_id, actuals = [_h | _t]) do
    Actual.create(name, sv_id, actuals)
  end

  @spec next_value(state :: SIPmath.State.t) :: State.t_next_value
  def next_value(state) do
    state
    |> state.type.next_value()
    |> State.increment_index()
  end

  @spec as_stream(state :: SIPmath.State.t) :: Enumerable.t
  def as_stream(state) do
    state
    |> Stream.unfold(fn state -> next_value(state) end)
  end

  @spec apply_function_to_list(states :: list(SIPmath.State.t), fun :: (any -> any), trials :: integer) :: Enumerable.t
  def apply_function_to_list(states, fun, trials) do
      states
      |> Enum.map(&(SIPmath.as_stream(&1)))
      |> Stream.zip()
      |> Stream.map(fun)
      |> Enum.take(trials)
  end
  
end
