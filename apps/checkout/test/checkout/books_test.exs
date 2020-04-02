defmodule Checkout.BooksTest do
  use ExUnit.Case
  alias Checkout.Books

  setup do
    book = %Books.Book{
      title: "The Book of Foo",
      author: "Bar",
      isbn: "Baz",
      count: 1
    }

    Books.add(book)

    table =
      Application.get_env(
        :checkout,
        :books_table_name,
        :books_table
      )

    on_exit(fn ->
      Books.dump()
    end)

    [book: book, table: table]
  end

  describe "add/1" do
    test "can add a new book to the library", %{book: book, table: table} do
      Books.dump()

      Books.add(book)

      [{_, added_book}] = :dets.lookup(table, book.isbn)

      assert added_book == book
    end

    test "if the book already exists, it is replaced", %{book: book, table: table} do
      book
      |> Map.put(:title, "Foo")
      |> Books.add()

      [{_, updated_book}] = :dets.lookup(table, book.isbn)

      assert updated_book != book
    end
  end
end
