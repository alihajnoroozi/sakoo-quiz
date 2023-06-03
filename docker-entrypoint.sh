#!/bin/sh
export DATABASE_URL=ecto://$POSTGRES_USERNAME:$POSTGRES_PASSWORD@$POSTGRES_HOST:5432/$POSTGRES_DB
echo DB $DATABASE_URL
mix phx.digest
mix ecto.create
mix ecto.migrate
mix run /quiz/priv/repo/seeds.exs
mix phx.server