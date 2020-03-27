defmodule Checkout.Admins do
  use GenServer

  # Client API

  def start_link(default) when is_list(default) do
    {:ok, pid} = GenServer.start_link(__MODULE__, default)
    Process.register(pid, :admins)
    {:ok, pid}
  end

  def add(admin) do
    GenServer.cast(:admin, {:add, admin})
  end

  def remove(username) do
    GenServer.cast(:admins, {:remove, username})
  end

  def update_field(username, field, data) do
    GenServer.cast(:admins, {:update_field, username, field, data})
  end

  def lookup(username) do
    GenServer.call(:admins, {:lookup, username})
  end

  def list_all() do
    GenServer.call(:admins, :list_all)
  end

  # GenServer Callbacks

  @impl true
  def init(_list) do
    {:ok, table} = Application.get_env(
      :checkout,
      :admins_table_name,
      :admins_table
    )
    |> :dets.open_file(type: :set)

    # Creates a default Admin if one doesn't exist.
    :dets.insert_new(
      table,
      {
        "admin",
        %__MODULE__.Admin{
          username: "admin",
          # TODO: Change to hashed password.
          password_hash: "admin"
        }
      }
    )

    spawn(fn ->
      # Sends the signal after 10 minutes.
      Process.send_after(:admins, :reopen_table, 600_000)
    end)

    {:ok, table}
  end

  @impl true
  def handle_info(:reopen_table, table) do
    :dets.sync(table)

    :dets.close(table)

    {:ok, reopened_table} = Application.get_env(
      :checkout,
      :admins_table_name,
      :admins_table
    )
    |> :dets.open_file(type: :set)


    spawn(fn ->
      # Sends the signal after 10 minutes.
      Process.send_after(:admins, :reopen_table, 600_000)
    end)

    {:noreply, reopened_table}
  end

  @impl true
  def handle_cast({:add, %__MODULE__.Admin{username: username} = admin}, table) do
    :dets.insert(table, {username, admin})
    {:noreply, table}
  end

  @impl true
  def handle_cast({:remove, username}, table) do
    :dets.delete(table, username)
    {:noreply, table}
  end

  @impl true
  def handle_cast({:update_field, username, field, data}, table) do
    [{_, admin}] = :dets.lookup(table, username)
    :dets.insert(table, {username, Map.put(admin, field, data)})
    {:noreply, table}
  end

  @impl true
  def handle_call({:lookup, username}, _from, table) do
    [{_, admin}] = :dets.lookup(table, username)
    {:reply, admin, table}
  end

  @impl true
  def handle_call(:list_all, _from, table) do
    list = :dets.traverse(table, fn x -> {:continue, x} end)
    {:reply, list, table}
  end
end
