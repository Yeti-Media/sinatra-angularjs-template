require 'rubygems'
require 'bundler'
require "sinatra/json"

Bundler.require

Mongoid.load!("config/database.yml", ENV['RACK_ENV'])

Dir['./lib/**/*.rb'].each do |file|
  require file
end
 

use Rack::NoWWW
use Rack::Static, :urls => ["/js","/images" ,"/css", "/app"], :root => "public"

use Rack::Session::Cookie, :secret => 'secret_token'

map "/api" do 
 run MyApp::Api
end

map "/users" do 
 run MyApp::Users
end
