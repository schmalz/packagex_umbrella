defmodule Packagex.Application do
  use Application

  @moduledoc """
  The Packagex Application Service.

  The packagex system business domain lives in this application.

  Exposes API to clients such as the `PackagexWeb` application for use in channels, controllers, and elsewhere.
  """

  @doc """
  Start the application.
  """
  def start(_type, _args), do: Packagex.Supervisor.start_link(nil)
end

