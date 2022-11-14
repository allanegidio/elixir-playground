defmodule LiveflashWeb.OrganizationLive do
  use LiveflashWeb, :live_view

  alias Liveflash.Organizations
  alias Liveflash.Organizations.Organization

  def mount(_params, _session, socket) do
    changeset = Organizations.change_organization(%Organization{})

    socket =
      socket
      |> assign(
        changeset: changeset,
        current_step: 1
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="px-2">
      <h1 class="mb-4 font-weight-light">Organization</h1>
      <.simple_form :let={f} for={@changeset} phx-change="validate" phx-submit="create-organization">
        <div style={unless @current_step == 1, do: "visibility: hidden;"}>
          <div>
            <h5>Step: <%= @current_step %></h5>
          </div>

          <.input field={{f, :name}} type="text" label="name" />

          <br />

          <.input field={{f, :document}} type="text" label="document" />

          <br />
        </div>

        <div style={unless @current_step == 2, do: "visibility: hidden;"}>
          <div>
            <h5>Step: <%= @current_step %></h5>
          </div>

          <.input field={{f, :last_name}} type="text" label="name" />
        </div>

        <div style={unless @current_step == 3, do: "visibility: hidden;"}>
          <div>
            <h5>Step: <%= @current_step %></h5>
          </div>

          <.input field={{f, :age}} type="number" label="age" />
        </div>

        <%= if @current_step > 1 do %>
          <.button type="button" phx-click="prev-step">Back</.button>
        <% end %>

        <%= if @current_step == 3 do %>
          <.button type="submit" phx-disable-with="Registering...">
            Register
          </.button>
        <% else %>
          <.button type="button" phx-click="next-step">Continue</.button>
        <% end %>
      </.simple_form>
    </div>
    """
  end

  def handle_event("validate", %{"organization" => params}, socket) do
    changeset =
      %Organization{}
      |> Organizations.change_organization(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("prev-step", _value, socket) do
    new_step = max(socket.assigns.current_step - 1, 1)
    {:noreply, assign(socket, :current_step, new_step)}
  end

  def handle_event("next-step", _value, socket) do
    current_step = socket.assigns.current_step

    new_step = current_step + 1

    {:noreply, assign(socket, :current_step, new_step)}
  end

  def handle_event("create-organization", %{"organization" => organization_params}, socket) do
    case Organizations.create_organization(organization_params) do
      {:ok, _organization} ->
        socket =
          socket
          |> put_flash(:info, "OK")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket =
          socket
          |> put_flash(:error, "Erro Changeset")

        {:noreply, assign(socket, changeset: changeset)}

      {:error, _reason} ->
        socket =
          socket
          |> put_flash(:error, "Deu ruim")

        {:noreply, socket}
    end
  end
end
