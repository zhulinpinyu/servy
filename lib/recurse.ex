defmodule Recurse do
  def loopy([head | tail], sum) do
    sum = sum + head
    loopy(tail, sum)
  end

  def loopy([], sum), do: sum
end

IO.puts Recurse.loopy([1, 2, 3, 4, 5], 0)
