json.array!(@playlists) do |playlist|
  json.extract! playlist, :id, :url, :title, :mood
  json.url playlist_url(playlist, format: :json)
end
