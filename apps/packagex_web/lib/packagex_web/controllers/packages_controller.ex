defmodule PackagexWeb.PackagesController do
  use PackagexWeb, :controller

  def create(conn, params) do
    id = Packagex.Packages.add(params)
    PackagexWeb.Endpoint.broadcast("packages:packages", "updated", %{})
    conn
    |> put_resp_header("location", PackagexWeb.Router.Helpers.packages_path(conn, :show, id))
    |> send_resp(201, "")
  end

  def show(conn, %{"id" => id, "currency" => currency}) do
    case Packagex.Packages.read(id, currency) do
      nil -> send_resp(conn, 404, "")
      package -> json(conn, package)
    end
  end
  def show(conn, %{"id" => id}) do
    case Packagex.Packages.read(id) do
      nil -> send_resp(conn, 404, "")
      package -> json(conn, package)
    end
  end

  def update(conn, params) do
    case Packagex.Packages.update(params) do
      true ->
        PackagexWeb.Endpoint.broadcast("packages:packages", "updated", %{})
        send_resp(conn, 204, "")
      false -> send_resp(conn, 404, "")
    end
  end

  def delete(conn, %{"id" => id}) do
    case Packagex.Packages.delete(id) do
      true ->
        PackagexWeb.Endpoint.broadcast("packages:packages", "updated", %{})
        send_resp(conn, 204, "")
      false -> send_resp(conn, 404, "")
    end
  end

  def index(conn, _params), do: json(conn, Packagex.Packages.read_all())
end

