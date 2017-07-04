defmodule Servy.Parser do
  def parse(request) do
    [top, params_string] = String.split(request, "\n\n")

    [request_line|header_lines] = String.split(top, "\n")

    [method, path, _] = request_line |> String.trim |> String.split(" ")

    params = params_string |> String.trim |> URI.decode_query

    %Servy.Conv{
      method: method,
      path: path,
      params: params
    }
  end
end
