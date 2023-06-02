FROM elixir:1.13.4-otp-25-alpine as build_elixir
WORKDIR /quiz
COPY mix.exs mix.lock /quiz/
RUN mix local.hex --force && mix local.rebar --force
RUN mix deps.get
COPY . .
ARG MIX_ENV=prod
ARG JWT_SIGN_KEY=834991a53e1c3c572448438598efa1a720821734fb773034df9af5fc57a70718
ARG DATABASE_URL=ecto://USER:PASS@HOST/DATABASE
RUN mix compile

FROM node:14-alpine as build_node
WORKDIR /quiz
COPY --from=build_elixir /quiz/assets /quiz/assets
COPY --from=build_elixir /quiz/deps /quiz/deps
RUN npm install --prefix ./assets
RUN npm run deploy --prefix ./assets

FROM elixir:1.13.4-otp-25-alpine as runtime
WORKDIR /quiz
COPY --from=build_elixir /root/.mix /root/.mix
COPY --from=build_elixir /quiz /quiz
COPY --from=build_node /quiz/assets /quiz/assets
ARG MIX_ENV=prod
ARG JWT_SIGN_KEY=834991a53e1c3c572448438598efa1a720821734fb773034df9af5fc57a70718
ARG DATABASE_URL=ecto://USER:PASS@HOST/DATABASE
RUN mix phx.digest
CMD ["mix", phx.server]