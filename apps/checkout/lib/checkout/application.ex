defmodule Checkout.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Checkout.Books,
      Checkout.Cards,
      Checkout.Admins
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Checkout.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
