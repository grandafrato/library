defmodule Checkout.Books do
  use GenServer

  # Client API

  def start_link(default) when is_list(default) do
    {:ok, pid} = GenServer.start_link(__MODULE__, default)
    Process.register(pid, :books)
    {:ok, pid}
  end

  def add(book) do
    GenServer.cast(:books, {:add, book})
  end

  def remove_by_isbn(isbn) do
    GenServer.cast(:books, {:remove_by_isbn, isbn})
  end

  def dump() do
    GenServer.cast(:books, :dump)
  end

  def update_field_by_isbn(isbn, field, data) do
    GenServer.cast(:books, {:update_field_by_isbn, isbn, field, data})
  end

  def lookup_by_isbn(isbn) do
    GenServer.call(:books, {:lookup_by_isbn, isbn})
  end

  def list_all() do
    GenServer.call(:books, :list_all)
  end

  # GenServer Callbacks

  @impl true
  def init(_list) do
    {:ok, table} = :dets.open_file(:books_table, [type: :set])

    spawn(fn ->
      Process.send_after(:books, :reopen_table, 600000)
    end)

    {:ok, table}
  end

  @impl true
  def handle_info(:reopen_table, table) do
    :dets.sync(table)

    :dets.close(table)
    {:ok, reopened_table} = :dets.open_file(:books_table, [type: :set])

    spawn(fn ->
      Process.send_after(:books, :reopen_table, 600000)
    end)

    {:noreply, reopened_table}
  end

  @impl true
  def handle_cast({:add, %__MODULE__.Book{isbn: isbn} = book}, table) do
    :dets.insert(table, {isbn, book})
    {:noreply, table}
  end

  @impl true
  def handle_cast({:remove_by_isbn, isbn}, table) do
    :dets.delete(table, isbn)
    {:noreply, table}
  end

  @impl true
  def handle_cast(:dump, table) do
    :dets.delete_all_objects(table)
    {:noreply, table}
  end

  @impl true
  def handle_cast({:update_field_by_isbn, isbn, field, data}, table) do
    [{_, book}] = :dets.lookup(table, isbn)
    :dets.insert(table, {isbn, Map.put(book, field, data)})
    {:noreply, table}
  end

  @impl true
  def handle_call({:lookup_by_isbn, isbn}, _from, table) do
    [{_, book}] = :dets.lookup(table, isbn)
    {:reply, book, table}
  end

  @impl true
  def handle_call(:list_all, _from, table) do
    list = :dets.traverse(table, fn x -> {:continue, x} end)
    {:reply, list, table}
  end
end
