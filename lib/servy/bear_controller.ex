defmodule Servy.BearController do

  alias Servy.Wildthings
  alias Servy.Bear

  @templates_path Path.expand("templates", File.cwd!)

  defp render(conv, template, binding \\[]) do
     content = @templates_path
     |> Path.join(template)
     |> EEx.eval_file(binding)

    %{conv | status: 200, resp_body: content}
  end

  def index(conv) do
    bears =
      Wildthings.list_bears
      |> Enum.sort(&Bear.order_asc_with_name/2)

    render(conv, "index.eex", bears: bears)
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    render(conv, "show.eex", bear: bear)
  end

  def create(conv, %{"name" => name, "type" => type}) do
    %{conv | status: 200, resp_body: "Created a #{type} bear named #{name}!"}
  end

  def delete(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    %{conv | status: 200, resp_body: "<b>DELETED name: #{bear.name}, id: #{bear.id}</b>"}
  end
end
