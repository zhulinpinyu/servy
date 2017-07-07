defmodule DocTest do
  use ExUnit.Case, async: true
  doctest Servy.Handler
  doctest Servy.Parser
  doctest Servy
end