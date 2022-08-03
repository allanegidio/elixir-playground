defmodule LiveViewStudioWeb.FlightsLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Flights
  alias LiveViewStudio.Airports

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(
        flight: "",
        flights: [],
        number: "",
        airport: "",
        matches: [],
        loading: false
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

      <form phx-change="suggest-airport" phx-submit="airport-search">
        <input
          type="text"
          name="airport"
          value={@airport}
          placeholder="Airport Name"
          autocomplete="off"
          list="matches"
          readonly={@loading}
        />
        <button>
          <img src="images/search.svg" />
        </button>
      </form>

      <datalist id="matches">
        <%= for match <- @matches do %>
          <option value={match}><%= match %></option>
        <% end %>
      </datalist>

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

  def handle_event("airport-search", %{"airport" => airport}, socket) do
    send(self(), {:run_airport_search, airport})

    socket =
      socket
      |> assign(
        airport: airport,
        flights: [],
        loading: true
      )

    {:noreply, socket}
  end

  def handle_event("suggest-airport", %{"airport" => airport}, socket) do
    socket =
      assign(socket,
        matches: Airports.suggest(airport)
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

  def handle_info({:run_airport_search, airport}, socket) do
    case Flights.search_by_airport(airport) do
      [] ->
        socket =
          socket
          |> put_flash(:info, "No airport matching #{airport}")
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
