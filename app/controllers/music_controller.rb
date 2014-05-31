class MusicController < ApplicationController

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
    client = OAuth2::Client.new('d0ca7c8afa63021bd17991617a5fb275', '9a9c959fcc7ad49bf85fdbae78b82392', :site => 'http://api.soundcloud.com')

    asdw = client.auth_code.authorize_url(:redirect_uri => 'http://vitalmusicccc.com:3000/oauth2/callback')
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

  end

  def test
    render json: { test: 'OK' }
  end
end
