defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> log
    |> rewrite_path
    |> route
    |> emojify
    |> track
    |> format_response
  end

  def emojify(%{status: 200, resp_body: resp_body} = conv) do
    emojies = String.duplicate(" 🎉 ", 5)
    %{conv | resp_body: emojies <> "\n" <> resp_body <> "\n" <> emojies }
  end

  def emojify(conv), do: conv

  def track(%{ status: 404 } = conv) do
    IO.puts "[Warning:] not found"
    conv
  end

  def track(conv), do: conv

  def rewrite_path(%{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(%{path: path} = conv) do
    regex = ~r{\/(?<things>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(conv, captures)
  end

  def rewrite_path_captures(conv, %{"things" => things, "id" => id}) do
    %{conv | path: "/#{things}/#{id}"}
  end

  def rewrite_path_captures(conv, nil), do: conv

  def rewrite_path(conv), do: conv

  def log(conv), do: IO.inspect conv

  def parse(request) do
    [method, path, _] = request
      |> String.split("\n")
      |> List.first
      |> String.split(" ")

    %{
      method: method,
      status: nil,
      path: path,
      resp_body: ""
    }
  end

  def route(%{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%{method: "GET", path: "/bears"} = conv) do
    %{conv | status: 200, resp_body: "Bears 熊🐻"}
  end

  def route(%{method: "GET", path: "/bears/" <> id } = conv) do
    %{conv | status: 200, resp_body: "Bears #{id}"}
  end

  def route(%{method: "DELETE", path: "/bears/" <> id } = conv) do
    %{conv | status: 200, resp_body: "DELETED Bears #{id}"}
  end

  def route(%{ path: path } = conv) do
    %{conv | status: 404, resp_body: "Not Found #{path} 😬"}
  end

  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      405 => "Internal Server Error"
    }[code]
  end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)

request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)

request = """
DELETE /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)


request = """
GET /bears?id=1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)
