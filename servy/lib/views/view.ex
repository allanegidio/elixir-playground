defmodule Servy.View do
  alias Servy.Conv

  @templates_path Path.expand("templates", File.cwd!())

  def render(conv, template, bindings \\ []) do
    content =
      @templates_path
      |> Path.join(template)
      |> EEx.eval_file(bindings)

    %Conv{conv | status: 200, resp_body: content}
  end
end
