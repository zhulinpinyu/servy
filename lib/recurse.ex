defmodule Recurse do
  def loopy([head | tail], sum) do
    sum = sum + head
    loopy(tail, sum)
  end

  def loopy([], sum), do: sum

  def triple([h|t], ret) do
    ret = ret ++ [ h * 3 ]
    triple(t, ret)
  end

  def triple([], ret), do: ret
end

IO.puts Recurse.loopy([1, 2, 3, 4, 5], 0)

IO.inspect Recurse.triple([1, 2, 3, 4, 5], [])
