class MusicController < ApplicationController
  require 'open-uri'
  require 'json'

  def login
    client = OAuth2::Client.new('rbLG7rmUK1o', 'c247ecec1755768e0c0e9bfca7f4a20184613b4b', :site => 'https://jawbone.com/auth/oauth2/auth', scope: 'basic_read,extended_read,mood_read,move_read,sleep_read,meal_read')
    aa = client.auth_code.authorize_url(redirect_uri: 'https://vital-music.herokuapp.com/oauth2/callback')
    redirect_to 'https://jawbone.com/auth/oauth2/auth?client_id=rbLG7rmUK1o&redirect_uri=https%3A%2F%2Fvital-music.herokuapp.com%2Foauth2%2Fcallback&response_type=code&scope=basic_read%20extended_read%20mood_read%20move_read%20sleep_read%20meal_read'

    # https://jawbone.com/auth/oauth2/token?client_id=rbLG7rmUK1o&client_secret=c247ecec1755768e0c0e9bfca7f4a20184613b4b&grant_type=authorization_code&code=W3AjaI7_iOWexGQfHbv4wELsustPIqURfbsNv7J6JdQanOinwTqbJ-XrW6uRY9jFUQJ2BGWj8ZQsyAZlLQS6bNlJFKJPK1kp5e3em0hDqIvq35w0EBzaWLr_yIKeSKqnxRx0Sty4SKVRvTgik1vmyZFMVrnSCOs67RrSfjn7XUSXgvsAuL7BLWuVwux6cxHLKCpQnnWinrPk8lNHm2EhXRvdWVs4RN1C
  end

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
    code = params['code']
    session[:code] = code
    render json: { code: code }
  end

  def check
    skip_check = false
    result = get_response('meals')
    if result['data']['size'] > 0
      last_meal = result['data']['items'].last
      last_meal_timestamp = session['last_meal_timestamp'] ||= 0
      if last_meal['time_created'] > last_meal_timestamp
        session['last_meal_timestamp'] = last_meal['time_created']
        mood = "Relaxing"
        skip_check = true
      end
    end

    unless skip_check
      result = get_response('mood')
      mood = result['data']['title']
    end

    tracks = get_playlist(mood, true)
    render json: tracks
  end


  def playlist
    mood = params[:mood]

    tracks = get_playlist(mood, false)

    render json: tracks
  end


  def get_playlist(mood, with_pid)
    playlist_id = ''
    pid = 1

    # AI Algorithm
    case mood
      when '5'
        playlist_id = '37496379' #angry
        pid = 5
      when '3'
        playlist_id = '37495759' #workout
        pid = 3
      when '4'
        playlist_id = '37495323' #sad
        pid = 4
      when '2'
        playlist_id = '37494998' #exciting
        pid = 2
      when '1'
        playlist_id = '37494896' #relax
        pid = 1
      when 'Wakeup'
        playlist_id = '37494998' #exciting
        pid = 2
      when 'Sleepy'
        playlist_id = '37494896' #relax
        pid = 1
      when 'Sad'
        playlist_id = '37495323' #sad
        pid = 4
      when 'Relaxing'
        playlist_id = '37494896' #relax
        pid = 1
      else
        playlist_id = '1'
        pid = 1
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

    if with_pid
      response = [ playlist_id: pid, tracks: tracks ]
    else
      tracks
    end

  end

  def test
    render json: { a: get_response(params[:endpoint]) }
  end

  def client
    OAuth2::Client.new('rbLG7rmUK1o', 'c247ecec1755768e0c0e9bfca7f4a20184613b4b', :site => 'https://jawbone.com/auth/oauth2/auth', scope: 'basic_read,extended_read,mood_read,move_read,sleep_read,meal_read')
  end

  def get_response(url)
    session[:access_token] = 'aV1SI82xvTpL9tC0ZC4HQ0h8l1O0O7nqnsRkHx27-MBC7LrLTyKlEVAykT19yBwz8c9QkoSzRYjl61urkWPYxVECdgRlo_GULMgGZS0EumxrKbZFiOmnmAPChBPDZ5JP'
    access_token = OAuth2::AccessToken.new(client, session[:access_token])
    JSON.parse(access_token.get("/nudge/api/v.1.1/users/@me/#{url}").body)
  end
end
