defmodule Spotify do
  @moduledoc """
  Wrapper functions for interacting with the Spotify API.
  By default, they will retry with a refreshed API token if the
  initial request fails. This may be bypassed by specifying
  0 retries.
  """

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
