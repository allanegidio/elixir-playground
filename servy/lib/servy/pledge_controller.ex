defmodule Servy.PledgeController do
  alias Servy.PledgeServer
  alias Servy.View

  def new(conv) do
    View.render(conv, "new_pledge.eex")
  end

  def create(conv, %{"name" => name, "amount" => amount}) do
    # Sends the pledge to the external service and caches it
    pledge = PledgeServer.create_pledge(name, String.to_integer(amount))

    %{conv | status: 201, resp_body: inspect(pledge)}
  end

  def index(conv) do
    # Gets the recent pledges from the cache
    pledges = PledgeServer.recent_pledges()

    View.render(conv, "recent_pledges.eex", pledges: pledges)
  end
end
