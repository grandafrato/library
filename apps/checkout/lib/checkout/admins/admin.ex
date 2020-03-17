defmodule Checkout.Admins.Admin do
  defstruct [:username, :password_hash, rights: :superuser]
end
