defmodule HandlerTest do
  use ExUnit.Case, async: true

  alias Servy.Handler

  test "Handler handle request [GET]" do
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

  test "Handler handle request [DELETE]" do
    request = """
    DELETE /bears/1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r

    """
    response = Handler.handle(request)
    assert response == """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 65

     🎉  🎉  🎉  🎉  🎉 
    <b>DELETED name: Teddy, id: 1</b>
     🎉  🎉  🎉  🎉  🎉 
    """
  end
end
