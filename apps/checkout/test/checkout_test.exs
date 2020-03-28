defmodule CheckoutTest do
  use ExUnit.Case

  setup do
    card = Checkout.Cards.Card.new("foo", "bar")
    Checkout.Cards.add(card)

    book = %Checkout.Books.Book{
      title: "The Book of Foo",
      author: "Bar",
      isbn: "Baz",
      count: 1
    }

    Checkout.Books.add(book)

    on_exit(fn ->
      Checkout.Cards.dump()
      Checkout.Books.dump()
    end)

    [card_id: card.id, book_isbn: book.isbn]
  end

  test "is able to check out a book", %{card_id: id, book_isbn: isbn} do
    Checkout.checkout_book(id, isbn)

    %{checked_out_books: checked_out_books} = Checkout.Cards.lookup_by_id(id)
    assert checked_out_books == [Checkout.Books.lookup_by_isbn(isbn)]
  end

  test "is able to check out multiple copies of a book", %{card_id: id, book_isbn: isbn} do
    Checkout.checkout_book(id, isbn)
    Checkout.checkout_book(id, isbn)
    Checkout.checkout_book(id, isbn)

    book = Checkout.Books.lookup_by_isbn(isbn)

    %{checked_out_books: checked_out_books} = Checkout.Cards.lookup_by_id(id)
    assert checked_out_books == [book, book, book]
  end

  test "is able to return a book", %{card_id: id, book_isbn: isbn} do
    Checkout.checkout_book(id, isbn)

    %{checked_out_books: checked_out_books} = Checkout.Cards.lookup_by_id(id)

    Checkout.return_book(id, isbn)

    %{checked_out_books: updated_checked_out_books} = Checkout.Cards.lookup_by_id(id)

    assert updated_checked_out_books != checked_out_books
    assert updated_checked_out_books == []
  end

  test "is able to return multiple copies of a book", %{card_id: id, book_isbn: isbn} do
    Checkout.checkout_book(id, isbn)
    Checkout.checkout_book(id, isbn)
    Checkout.checkout_book(id, isbn)

    %{checked_out_books: checked_out_books} = Checkout.Cards.lookup_by_id(id)

    Checkout.return_book(id, isbn)
    Checkout.return_book(id, isbn)
    Checkout.return_book(id, isbn)

    %{checked_out_books: updated_checked_out_books} = Checkout.Cards.lookup_by_id(id)

    assert updated_checked_out_books != checked_out_books
    assert updated_checked_out_books == []
  end
end
