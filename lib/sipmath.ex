defmodule SIPmath do
  @moduledoc """
  Documentation for Sipmath.
  """

  @doc """
  Hello world.

  ## Examples

      iex1> SIPmath.uniform("abc", 1)
      :world

  """

  alias SIPmath.Distribution.{Uniform, Beta}
  alias SIPmath.State

  @spec uniform(name :: String.t, sv_id :: integer) :: SIPmath.State.t
  def uniform(name, sv_id) do
    Uniform.create(name, sv_id)
  end

  @spec beta(name :: String.t, sv_id :: integer, alpha :: integer, beta :: integer, a :: integer, b: integer) :: SIPmath.State.t
  def beta(name, sv_id, alpha, beta, a, b) do
    Beta.create(name, sv_id, alpha, beta, a, b)
  end

  @spec next_value(state :: SIPmath.State.t) :: State.t_next_value
  def next_value(state) do
    state
    |> state.type.next_value()
    |> State.increment_index()
  end

  @spec as_stream(state :: SIPmath.State.t) :: any
  def as_stream(state) do
    state
    |> Stream.unfold(fn state -> next_value(state) end)
  end

end
