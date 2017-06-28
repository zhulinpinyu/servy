defmodule Servy do
  @moduledoc """
  Documentation for Servy.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Servy.hello
      :world

  """
  def hello(name \\ "world") do
    "Hello, #{name}!"
  end
end

IO.puts Servy.hello