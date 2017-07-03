defmodule Servy.Plugins do

  alias Servy.Conv

  @doc "Log 404 status"
  def track(%Conv{ status: 404 } = conv) do
    IO.puts "[Warning:] not found"
    conv
  end

  def track(%Conv{} = conv), do: conv

  def rewrite_path(%Conv{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(%Conv{path: path} = conv) do
    regex = ~r{\/(?<things>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(conv, captures)
  end

  def rewrite_path(%Conv{} = conv), do: conv

  def rewrite_path_captures(%Conv{} = conv, %{"things" => things, "id" => id}) do
    %{conv | path: "/#{things}/#{id}"}
  end

  def rewrite_path_captures(%Conv{} = conv, nil), do: conv

  def log(%Conv{} = conv), do: IO.inspect conv
end
