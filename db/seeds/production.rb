def create_api_key
    api = ApiKey.new
    api.access_token = ENV.fetch("API_KEY")
    api.save
end

create_api_key()