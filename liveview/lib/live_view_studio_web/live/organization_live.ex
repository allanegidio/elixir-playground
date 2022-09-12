defmodule LiveViewStudioWeb.OrganizationLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Organizations
  alias LiveViewStudio.Organizations.Organization

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
      <.form let={f} for={@changeset} url="#" phx_change="validate" phx_submit="create-organization">
        <div style={unless @current_step == 1, do: "	visibility: hidden;"}>
          <div>
            <h5>Step: <%= @current_step %></h5>
          </div>

          <%= label f, :name %>
          <%= text_input f, :name %>
          <%= error_tag f, :name %>

          <br />

          <%= label f, :cnpj %>
          <%= text_input f, :cnpj %>
          <%= error_tag f, :cnpj %>

          <br />
        </div>

        <div style={unless @current_step == 2, do: "visibility: hidden;"}>
          <div>
            <h5>Step: <%= @current_step %></h5>
          </div>
          <%= inputs_for f, :address, fn fa -> %>
            <%= label fa, :postal_code %>
            <%= text_input fa, :postal_code %>
            <%= error_tag fa, :postal_code %>

            <br />

            <%= label fa, :primary_address %>
            <%= text_input fa, :primary_address %>
            <%= error_tag fa, :primary_address %>

            <br />

            <%= label fa, :state %>
            <%= text_input fa, :state %>
            <%= error_tag fa, :state %>

            <br />

            <%= label fa, :city %>
            <%= text_input fa, :city %>
            <%= error_tag fa, :city %>
          <% end %>
        </div>

        <div style={unless @current_step == 3, do: "visibility: hidden;"}>
          <div>
            <h5>Step: <%= @current_step %></h5>
          </div>

          <%= inputs_for f, :contact, fn fc -> %>
            <%= label fc, :phone %>
            <%= text_input fc, :phone %>
            <%= error_tag fc, :phone %>

            <br />

            <%= label fc, :website %>
            <%= text_input fc, :website %>
            <%= error_tag fc, :website %>
          <% end %>
        </div>

        <%= if @current_step > 1 do %>
          <button type="button" phx-click="prev-step">Back</button>
        <% end %>

        <%= if @current_step == 3 do %>
          <%= submit "Register", phx_disable_with: "Registering..." %>
        <% else %>
          <button type="button" phx-click="next-step">Continue</button>
        <% end %>
      </.form>
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
