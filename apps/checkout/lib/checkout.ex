defmodule Checkout do
  @moduledoc """
  Documentation for `Checkout`.
  """

  def checkout_book(card_id, isbn) do
    book = Checkout.Books.lookup_by_isbn(isbn)
    card = Checkout.Cards.lookup_by_id(card_id)

    Checkout.Cards.update_field_by_id(
      card_id,
      :checked_out_books,
      [book | Map.fetch!(card, :checked_out_books)]
    )
  end

  def return_book(card_id, isbn) do
    book = Checkout.Books.lookup_by_isbn(isbn)
    card = Checkout.Cards.lookup_by_id(card_id)

    Checkout.Cards.update_field_by_id(
      card_id,
      :checked_out_books,
      List.delete(Map.fetch!(card, :checked_out_books), book)
    )
  end
end
