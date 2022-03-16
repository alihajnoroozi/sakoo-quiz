defmodule Mafia.Sessions do

  def create_session(jwt) do
    jwt
  end

  def generate_jwt_token!(params) do
    Mafia.Joken.generate_and_sign!(params)
  end

  def get_claims_from_jwt_token(jwt_token) do
    Mafia.Joken.verify_and_validate(jwt_token)
  end

end