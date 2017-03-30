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

  @spec uniform(name :: String.t, sv_id :: integer) :: SIPmath.State.t
  def uniform(name, sv_id), do: Uniform.create(name, sv_id)

  def next_value(state) do
    state
    |> state.type.next_value()
  end

  @spec as_stream(state :: SIPmath.State.t) :: any
  def as_stream(state) do
    state
    |> Stream.unfold(fn state -> next_value(state) end)
  end

end
