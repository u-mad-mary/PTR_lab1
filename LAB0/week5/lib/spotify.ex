defmodule SpotifyServer do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/callback" do
    send_resp(conn, 200, Spotify.auth())
  end

  def start do
    options = [port: 4000]
    Plug.Cowboy.http(SpotifyServer, [], options)
  end
end

defmodule Spotify do
  use HTTPoison.Base
  require Logger

  @client_id ""
  @client_secret ""
  @redirect_uri "http://localhost:4000/callback"

  def auth do
    "https://accounts.spotify.com/authorize" <>
      "?response_type=code" <>
      "&client_id=" <> @client_id <>
      "&scope=ugc-image-upload playlist-modify-private playlist-modify-public user-read-email user-read-private" <>
      "&redirect_uri=" <> @redirect_uri
  end

  def get_access_token(code) do
    url = "https://accounts.spotify.com/api/token"
    headers = [
      {"Content-Type", "application/x-www-form-urlencoded"},
      {"Authorization", "Basic #{Base.encode64("#{@client_id}:#{@client_secret}")}"}
    ]
    body = "grant_type=authorization_code&code=#{code}&redirect_uri=#{@redirect_uri}"
    {:ok, response} = HTTPoison.post(url, body, headers)
    response_body = Poison.decode!(response.body)
    access_token = response_body["access_token"]
    {:ok, access_token}
  end
end

defmodule SpotifyAPI do

  @base_url "https://api.spotify.com/v1"

  def create_playlist(access_token, user_id, playlist_name, description) do
    url = "#{@base_url}/users/#{user_id}/playlists"
    headers = [
      {"Authorization", "Bearer #{access_token}"},
      {"Content-Type", "application/json"}
    ]
    body = %{name: playlist_name, description: description}
    HTTPoison.post(url, Poison.encode!(body), headers)
  end

  def add_tracks_to_playlist(access_token, playlist_id, track_uris) do
    url = "#{@base_url}/playlists/#{playlist_id}/tracks"
    headers = [
      {"Authorization", "Bearer #{access_token}"},
      {"Content-Type", "application/json"}
    ]
    body = %{uris: track_uris}
    HTTPoison.post(url, Poison.encode!(body), headers)
  end

  def add_playlist_cover_image(access_token, playlist_id, image_path) do
    url = "#{@base_url}/playlists/#{playlist_id}/images"
    headers = [
      {"Authorization", "Bearer #{access_token}"},
      {"Content-Type", "image/jpeg"}
    ]
    image_data = File.read!(image_path) #"./lib/hehe.jpg"
    encoded_image = Base.encode64(image_data)
    HTTPoison.put(url, encoded_image, headers)
  end
end
