defmodule Checkout.Cards.Card do
  @enforce_keys [:id]
  defstruct [:id, :first_name, :last_name, checked_out_books: []]
end
