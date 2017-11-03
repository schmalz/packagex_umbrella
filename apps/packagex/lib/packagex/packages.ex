defmodule Packagex.Packages do
  use GenServer

  @moduledoc """
  A simple service that allows basic manipulation of a collection of packages.

  Packages are identified by a unique identifiers and contain a list of one or more products.
  """

  # Client API

  @doc """
  Start the Packages Service.
  """
  def start_link(_), do: GenServer.start_link(__MODULE__, nil, name: __MODULE__)

  @doc """
  Read all packages from the collection.
  """
  def read_all(), do: GenServer.call(__MODULE__, :read_all)

  @doc """
  Add a package to the collection and return its newly-assigned identifier.

  `Package` should be minimally populated, the `id` and `price` fields and the product fields `name` and `usdPrice` will
  be populated by this method as the package is stored in the collection.
  """
  def add(package), do: GenServer.call(__MODULE__, {:add, package})

  @doc """
  Read a package from the collection.

  The total package price will be given in units of `currency` (defaults to
  `Packagex.ExchangeRateService.base_currency_symbol/1`).
  """
  def read(id, currency \\ Packagex.ExchangeRateService.base_currency_symbol()) do
    GenServer.call(__MODULE__, {:read, id, currency})
  end

  @doc """
  Update a package in the collection.

  `Package` should be minimally populated, the `price` field and the product fields `name` and `usdPrice` will be
  populated by this method as the package is updated in the collection.

  Returns `true` if the package was successfully updated, `false` if the package could not be found.
  """
  def update(package), do: GenServer.call(__MODULE__, {:update, package})

  @doc """
  Delete a package from the collection.

  Returns `true` if the package was successfully deleted, `false` if the package could not be found.
  """
  def delete(id), do: GenServer.call(__MODULE__, {:delete, id})

  # Callbacks

  def init(_), do: {:ok, nil}

  def handle_call(:read_all, _from , _data), do: {:reply, Packagex.Store.read_all(), nil}
  def handle_call({:add, package}, _from, _data) do
    id =
      package
      |> populate_products()
      |> populate_price(Packagex.ExchangeRateService.base_currency_symbol())
      |> Packagex.Store.create()
    {:reply, id, nil}
  end
  def handle_call({:read, id, currency}, _from, _data) do
    case Packagex.Store.read(id) do
      nil -> {:reply, nil, nil}
      package -> {:reply, populate_price(package, currency), nil}
    end
  end
  def handle_call({:update, package}, _from, _data) do
    package =
      package
      |> populate_products()
      |> populate_price(Packagex.ExchangeRateService.base_currency_symbol())
    case Packagex.Store.update(package) do
      true -> {:reply, true, nil}
      _ -> {:reply, false, nil}
    end
  end
  def handle_call({:delete, id}, _from, _data) do
    case Packagex.Store.delete(id) do
      true -> {:reply, true, nil}
      _ -> {:reply, false, nil}
    end
  end

  # Private Functions

  defp populate_products(package) do
    Map.replace(package,
                "products",
                Enum.map(Map.get(package, "products"),
                                 &Map.merge(&1, Packagex.ProductService.product_info(Map.get(&1, "id")))))
  end

  defp populate_price(package, currency) do
    Map.put(package,
            "price",
            Packagex.ExchangeRateService.exchange_rate(currency) *
              Enum.reduce(Map.get(package, "products"), 0.0, &(Map.get(&1, "usdPrice", 0.0) + &2)))
  end
end

