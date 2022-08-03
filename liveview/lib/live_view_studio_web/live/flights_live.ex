defmodule LiveViewStudioWeb.FlightsLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Flights

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(
        flight: "",
        loading: false,
        flights: Flights.list_flights()
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Find a Flight</h1>
    <div id="search">
      <form phx-submit="flight-search">
        <input
          type="text"
          name="flight"
          value={@flight}
          placeholder="Flight Number"
          autofocus
          autocomplete="off"
          readonly={@loading}
        />
        <button>
          <img src="images/search.svg" />
        </button>
      </form>

      <%= if @loading do %>
        <div class="loader">Loading...</div>
      <% end %>

      <div class="flights">
        <ul>
          <%= for flight <- @flights do %>
            <li>
              <div class="first-line">
                <div class="number">
                  Flight #<%= flight.number %>
                </div>
                <div class="origin-destination">
                  <img src="images/location.svg">
                  <%= flight.origin %> to
                  <%= flight.destination %>
                </div>
              </div>
              <div class="second-line">
                <div class="departs">
                  Departs: <%= format_time(flight.departure_time) %>
                </div>
                <div class="arrives">
                  Arrives: <%= format_time(flight.arrival_time) %>
                </div>
              </div>
            </li>
          <% end %>
        </ul>
      </div>
    </div>
    """
  end

  def handle_event("flight-search", %{"flight" => flight}, socket) do
    send(self(), {:run_flight_search, flight})

    socket =
      socket
      |> assign(
        flight: flight,
        flights: [],
        loading: true
      )

    {:noreply, socket}
  end

  def handle_info({:run_flight_search, flight}, socket) do
    case Flights.search_by_number(flight) do
      [] ->
        socket =
          socket
          |> put_flash(:info, "No flights matching #{flight}")
          |> assign(flights: [], loading: false)

        {:noreply, socket}

      flights ->
        socket =
          socket
          |> clear_flash()
          |> assign(flights: flights, loading: false)

        {:noreply, socket}
    end
  end

  defp format_time(time) do
    Timex.format!(time, "{Mshort} {D} at {h24}:{m}")
  end
end
