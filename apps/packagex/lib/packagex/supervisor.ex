defmodule Packagex.Supervisor do
  use Supervisor

  @moduledoc """
  The top-level supervisor.
  """

  # Client API

  def start_link(arg), do: Supervisor.start_link(__MODULE__, arg, name: __MODULE__)

  # Callbacks

  def init(_arg) do
    children = [{Packagex.ExchangeRateService, nil},
                {Packagex.ProductService, nil},
                {Packagex.Store, nil},
                {Packagex.Packages, nil}]
    Supervisor.init(children, strategy: :one_for_one)
  end
end

