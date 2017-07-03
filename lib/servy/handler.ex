require Logger

defmodule Servy.Handler do

  @moduledoc """
    Http Process
  """
  import Servy.Plugins, only: [log: 1, rewrite_path: 1, track: 1]
  import Servy.FileHandler, only: [handle_file: 2]

  @pages_path Path.expand("../../pages", __DIR__)

  @doc "transform request to response"
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

  def route(%{method: "GET", path: "/bears/new"} = conv) do
    @pages_path
    |> Path.join("form.html")
    |> File.read
    |> handle_file(conv)
  end

  def route(%{method: "GET", path: "/bears/" <> id } = conv) do
    %{conv | status: 200, resp_body: "Bears #{id}"}
  end

  def route(%{method: "GET", path: "/about" } = conv) do
      @pages_path
      |> Path.join("about.html")
      |> File.read
      |> handle_file(conv)
  end

  def route(%{method: "GET", path: "/pages/" <> file } = conv) do
      @pages_path
      |> Path.join(file <> ".html")
      |> File.read
      |> handle_file(conv)
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

Logger.info "It's lunchtime somewhere."
Logger.warn "Do we have a problem, Houston?"
Logger.error "Danger Will Robinson!"

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)


request = """
GET /bears/new HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)

request = """
GET /pages/faq HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)

request = """
GET /pages/me HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)
