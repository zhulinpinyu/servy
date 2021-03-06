require Logger

defmodule Servy.Handler do

  @moduledoc """
    Http Process
  """

  alias Servy.Conv
  alias Servy.BearController

  @doc """
    import Servy.FileHandler, only: [handle_file: 2]
    意味着只导入有两个参数的 handle_file函数

    只导入module中的functions
    import SomeModule, only: :functions

    只导入module中的macros
    import SomeModule, only: :macros
  """
  import Servy.FileHandler, only: [handle_file: 2]
  import Servy.Plugins, only: [log: 1, rewrite_path: 1, track: 1]
  import Servy.Parser, only: [parse: 1]

  @pages_path Path.expand("pages", File.cwd!)

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

  def emojify(%Conv{status: 200, resp_body: resp_body} = conv) do
    emojies = String.duplicate(" 🎉 ", 5)
    %{conv | resp_body: emojies <> "\n" <> resp_body <> "\n" <> emojies }
  end

  def emojify(conv), do: conv

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/new"} = conv) do
    @pages_path
    |> Path.join("form.html")
    |> File.read
    |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id } = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

  def route(%Conv{method: "GET", path: "/about" } = conv) do
      @pages_path
      |> Path.join("about.html")
      |> File.read
      |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/pages/" <> file } = conv) do
      @pages_path
      |> Path.join(file <> ".html")
      |> File.read
      |> handle_file(conv)
  end

  def route(%Conv{method: "DELETE", path: "/bears/" <> id } = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.delete(conv, params)
  end

  def route(%Conv{method: "POST", path: "/bears", params: params} = conv) do
    BearController.create(conv, params)
  end

  def route(%Conv{ path: path } = conv) do
    %{conv | status: 404, resp_body: "Not Found #{path} 😬"}
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
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

request = """
POST /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Length: 21

name=Baloo&type=Brown
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
