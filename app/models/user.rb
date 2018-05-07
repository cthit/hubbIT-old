class User < ActiveResource::Base
  extend ActiveModel::Naming
  self.site = Rails.configuration.account_ip
end
