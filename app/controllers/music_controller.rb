class MusicController < ApplicationController
  require 'open-uri'
  require 'json'

  def mood

    # //render json: { asdas: 'asda' }
    # client = Soundcloud.new(:client_id => 'd0ca7c8afa63021bd17991617a5fb275')
    # # get 10 hottest tracks
    # tracks = client.get('/tracks', :limit => 10, :order => 'hotness')
    # # print each link
    # tracks.each do |track|
    #   puts track.permalink_url
    # end


    require 'oauth2'
    client = OAuth2::Client.new('d0ca7c8afa63021bd17991617a5fb275', '9a9c959fcc7ad49bf85fdbae78b82392', :site => 'https://soundcloud.com/connect')

    asdw = client.auth_code.authorize_url(:redirect_uri => 'http://vital-music.herokuapp.com/oauth2/callback')
    a = asdw
    # client.auth_code.authorize_url(:redirect_uri => 'http://localhost:3000/oauth2/callback')
    # => "https://example.org/oauth/authorization?response_type=code&client_id=client_id&redirect_uri=http://localhost:8080/oauth2/callback"

   # token = client.auth_code.get_token('authorization_code_value', :redirect_uri => 'http://localhost:3000/oauth2/callback', :headers => {'Authorization' => 'Basic some_password'})
    #response = token.get('/api/resource', :params => { 'query_foo' => 'bar' })
    # response.class.name
    # # => OAuth2::Response

    # render json: { asdas: 'asda' }

  end

  def callback
    render json: { a: params }
  end

  def playlist
    mood = params[:mood]
    playlist_id = ''

    # AI Algorithm
    case mood
      when '2'
        playlist_id = '37496379' #angry
      when '3'
        playlist_id = '37495759' #workout
      when '1'
        playlist_id = '37495323' #sad
      when '4'
        playlist_id = '37494998' #exciting
      when '5'
        playlist_id = '37494896' #relax
       else
        playlist_id = '1'
    end

    response = JSON.load(open("http://api.soundcloud.com/playlists/" + playlist_id + "?client_id=d0ca7c8afa63021bd17991617a5fb275&format=json").read)

    tracks = []
    if response['kind'] == 'playlist'
      response['tracks'].each do |t|
        tt = t.symbolize_keys.slice(:stream_url, :artwork_url, :title, :streamable)
        if tt[:streamable]
          tt[:stream_url] = tt[:stream_url] + '?client_id=d0ca7c8afa63021bd17991617a5fb275'
          tracks << tt
        end
      end
    end

    render json: tracks
  end

  def test
    render json: { test: 'OK' }
  end
end
