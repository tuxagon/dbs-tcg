use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :dbs_tcg, Dbs.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :dbs_tcg, Dbs.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "dbs_tcg_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
