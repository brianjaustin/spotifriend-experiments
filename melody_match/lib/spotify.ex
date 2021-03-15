defmodule Spotify do
  @moduledoc """
  Wrapper functions for interacting with the Spotify API.
  By default, they will retry with a refreshed API token if the
  initial request fails. This may be bypassed by specifying
  0 retries.
  """

  alias MelodyMatch.Accounts

  def get_tokens(user_id, :code, code) do
    url = "https://accounts.spotify.com/api/token"
    body = {:form, [
      {"grant_type", "authorization_code"},
      {"code", code},
      # TODO: this should be in config too
      {"redirect_uri", "http://localhost:4000/spotify/callback"}
    ]}
    
    client_id = Application.get_env(:melody_match, :spotify)[:client_id]
    client_secret = Application.get_env(:melody_match, :spotify)[:client_secret]
    auth = Base.encode64("#{client_id}:#{client_secret}")
    headers = ["Authorization": "Basic #{auth}", "Content-Type": "application/x-www-form-urlencoded"]

    response = HTTPoison.post!(url, body, headers)
    if response.status_code == 200 do
      toks = Jason.decode!(response.body)

      IO.inspect toks
      
      # TODO: make this be an upsert and remove the update function
      Accounts.create_spotify_token(%{
        user_id: user_id,
        auth_token: toks["access_token"],
        refresh_token: toks["refresh_token"]
      })
    else
      {:error, response.body}
    end
  end

  def get_tokens(user_id, :refresh, tokens) do
    # TODO
    %{}
  end

  def get_top_songs(tokens, limit \\ 1, retries \\ 1) do
    url = "https://api.spotify.com/v1/me/top/tracks?limit=#{limit}"
    headers = ["Authorization": "Bearer #{tokens.auth_token}"]
    response = HTTPoison.get!(url, headers)

    cond do
      response.status_code == 200 ->
        {:ok, response.body}
      retries > 0 ->
        # TODO: get new token via refresh token
        {:error, "Not yet implemented: RETRY"}
      true ->
        {:error, "Error fetching top tracks. Status #{response.status_code}."}
    end
  end
end
