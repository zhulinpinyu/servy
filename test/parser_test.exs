defmodule ParserTest do
  use ExUnit.Case, async: true

  alias Servy.Parser

  test "Parser parse_headers" do
    header_lines = ["A: 1", "B: 2"]
    assert %{"A" => "1", "B" => "2"} == Parser.parse_headers(header_lines, %{})
  end
end
