
def create_api_key
    api = ApiKey.new
    api.access_token = "123456789"
    api.save
end

create_api_key