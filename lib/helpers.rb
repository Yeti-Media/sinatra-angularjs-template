module MyApp
  module Helpers

    def current_user
      @current_user ||= User.where(id: session[:user_id]).first
    end

    def signed_in?
      current_user.present?
    end
    
    def authenticate!
      unless signed_in?
        halt 401, json(status: 'error' , error: 'Not Authenticated')
        return false
      end
    end

    def json_data
      @json_data ||= JSON.parse(request.body.read)
    end

  end
end
