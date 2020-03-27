use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :console, Console.Endpoint,
  http: [port: 4002],
  server: false

config :checkout,
  admins_table_name: :admins_table_test,
  cards_table_name: :cards_table_test,
  books_table_name: :books_table_test
