defmodule Servy.FileHandler do
  alias Servy.Conv

  def handle_file({:ok, content}, %Conv{} = conv) do
    %{conv | status: 200, resp_body: content}
  end

  def handle_file({:error, :enoent}, %Conv{} = conv) do
    %{conv | status: 404, resp_body: "file not found"}
  end

  def handle_file({:error, reason}, %Conv{} = conv) do
    %{conv | status: 500, resp_body: "Server Internal Error #{reason}"}
  end
end
