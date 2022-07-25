defmodule LiveViewStudioWeb.LightLive do
  use LiveViewStudioWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, :brightness, 10)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Front Porch Light</h1>
    <div id="light">
      <div class="meter">
        <span style={"width: #{@brightness}%"}>
          <%= @brightness %>%
        </span>
      </div>

      <button phx-click="off">
        <img src="images/light-off.svg">
      </button>

      <button phx-click="down">
        <img src="images/down.svg">
      </button>

      <button phx-click="random">
        <img src="images/refresh.svg">
      </button>

      <button phx-click="up">
        <img src="images/up.svg">
      </button>

      <button phx-click="on">
        <img src="images/light-on.svg">
      </button>
    </div>
    """
  end

  def handle_event("off", _value, socket) do
    socket = assign(socket, :brightness, 0)

    {:noreply, socket}
  end

  def handle_event("down", _value, socket) do
    socket = update(socket, :brightness, &(&1 - 10))

    {:noreply, socket}
  end

  def handle_event("on", _value, socket) do
    socket = assign(socket, :brightness, 100)

    {:noreply, socket}
  end

  def handle_event("up", _value, socket) do
    socket = update(socket, :brightness, &(&1 + 10))

    {:noreply, socket}
  end

  def handle_event("random", _value, socket) do
    socket = assign(socket, :brightness, Enum.random(0..100))

    {:noreply, socket}
  end
end
