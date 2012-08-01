require './lib/api_helpers.rb'

module MyApp

  class Api < Sinatra::Base

    helpers Sinatra::JSON
    include MyApp::ApiHelpers

    get "/ping" do
      json status: 'ok'
    end


  end
end
