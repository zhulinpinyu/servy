defmodule ServyTest do
  use ExUnit.Case
  doctest Servy.Handler

  alias Servy.Handler

  test "Handler handle request" do
    request = """
    GET /wildthings HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r

    """
    response = Handler.handle(request)
    assert response == """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 52

     🎉  🎉  🎉  🎉  🎉 
    Bears, Lions, Tigers
     🎉  🎉  🎉  🎉  🎉 
    """
  end
end
