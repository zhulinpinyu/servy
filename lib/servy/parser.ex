defmodule Servy.Parser do
  def parse(request) do
    [top, params_string] = String.split(request, "\n\n")

    [request_line|header_lines] = String.split(top, "\n")

    headers = parse_headers(header_lines, %{})
    [method, path, _] = request_line |> String.trim |> String.split(" ")

    params = parse_params(headers["Content-Type"], params_string)

    %Servy.Conv{
      method: method,
      path: path,
      params: params,
      headers: headers
    }
  end

  def parse_params("application/x-www-form-urlencoded", params_string) do
    params_string |> String.trim |> URI.decode_query
  end

  def parse_params(_, _), do: %{}

  def parse_headers([head | tail], headers) do
    [key, value] = head |> String.split(": ")
    headers = Map.put(headers, key, value)
    parse_headers(tail, headers)
  end

  def parse_headers([], headers), do: headers
end
