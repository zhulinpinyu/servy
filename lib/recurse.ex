defmodule Recurse do
  def loopy([head | tail], sum) do
    sum = sum + head
    loopy(tail, sum)
  end

  def loopy([], sum), do: sum

  def triple([h|t]) do
    [ h * 3 | triple(t) ]
  end

  def triple([]), do: []
end

IO.puts Recurse.loopy([1, 2, 3, 4, 5], 0)

IO.inspect Recurse.triple([1, 2, 3, 4, 5])
