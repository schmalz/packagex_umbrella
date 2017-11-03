defmodule PackagexWeb.PackagesChannel do
  use Phoenix.Channel

  @moduledoc """
  The packages channel.
  """

  @doc """
  Handle a topic join message.
  """
  def join("packages:packages", _message, socket), do: {:ok, socket}
  def join("packages:" <> _id, _message, _socket), do: {:error, %{reason: "unauthorized"}}

  @doc """
  Handle an incoming message.
  """
  def handle_in("read", %{"id" => id, "currency" => currency}, socket) do
    {:reply, {:ok, %{data: Packagex.Packages.read(id, currency)}}, socket}
  end
  def handle_in("read", %{"id" => id}, socket), do: {:reply, {:ok, %{data: Packagex.Packages.read(id)}}, socket}
  def handle_in("read_all", _message, socket), do: {:reply, {:ok, %{data: Packagex.Packages.read_all()}}, socket}
  def handle_in("updated" = event, data, socket) do
    broadcast(socket, event, data)
    {:noreply, socket}
  end
end

