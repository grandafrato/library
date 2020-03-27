defmodule Checkout.Cards do
  use GenServer

  # Client API

  def start_link(default) when is_list(default) do
    {:ok, pid} = GenServer.start_link(__MODULE__, default)
    Process.register(pid, :cards)
    {:ok, pid}
  end

  def add(card) do
    GenServer.cast(:cards, {:add, card})
  end

  def remove_by_id(id) do
    GenServer.cast(:cards, {:remove_by_id, id})
  end

  def dump() do
    GenServer.cast(:cards, :dump)
  end

  def update_field_by_id(id, field, data) do
    GenServer.cast(:cards, {:update_field_by_id, id, field, data})
  end

  def lookup_by_id(id) do
    GenServer.call(:cards, {:lookup_by_id, id})
  end

  def list_all() do
    GenServer.call(:cards, :list_all)
  end

  # GenServer Callbacks

  @impl true
  def init(_list) do
    {:ok, table} = Application.get_env(
      :checkout,
      :cards_table_name,
      :cards_table
    )
    |> :dets.open_file(type: :set)

    spawn(fn ->
      # Sends the signal after 10 minutes.
      Process.send_after(:cards, :reopen_table, 600_000)
    end)

    {:ok, table}
  end

  @impl true
  def handle_info(:reopen_table, table) do
    :dets.sync(table)

    :dets.close(table)

    {:ok, reopened_table} = Application.get_env(
      :checkout,
      :cards_table_name,
      :cards_table
    )
    |> :dets.open_file(type: :set)

    spawn(fn ->
      Process.send_after(:cards, :reopen_table, 600_000)
    end)

    {:noreply, reopened_table}
  end

  @impl true
  def handle_cast({:add, %__MODULE__.Card{id: id} = card}, table) do
    :dets.insert(table, {id, card})
    {:noreply, table}
  end

  @impl true
  def handle_cast({:remove_by_id, id}, table) do
    :dets.delete(table, id)
    {:noreply, table}
  end

  @impl true
  def handle_cast(:dump, table) do
    :dets.delete_all_objects(table)
    {:noreply, table}
  end

  @impl true
  def handle_cast({:update_field_by_id, id, field, data}, table) do
    [{_, card}] = :dets.lookup(table, id)
    :dets.insert(table, {id, Map.put(card, field, data)})
    {:noreply, table}
  end

  @impl true
  def handle_call({:lookup_by_id, id}, _from, table) do
    [{_, card}] = :dets.lookup(table, id)
    {:reply, card, table}
  end

  @impl true
  def handle_call(:list_all, _from, table) do
    list = :dets.traverse(table, fn x -> {:continue, x} end)
    {:reply, list, table}
  end
end
