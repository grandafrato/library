defmodule Checkout.Books.Book do
  @enforce_keys [:isbn]
  defstruct [:title, :author, :isbn, :count]
end
