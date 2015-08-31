# == Schema Information
#
# Table name: users
#
#  cid        :string(255)      primary key
#  total_time :integer
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
	include HTTParty
	has_many :devices, class_name: MacAddress
	has_many :sessions
	has_many :hour_entries, foreign_key: :cid
	has_many :user_sessions

	self.primary_key = :cid

	base_uri "https://account.chalmers.it/userInfo.php"

	accepts_nested_attributes_for :devices, allow_destroy: true

	def self.find_by_token(token)
		send_request query: { token: token }
	end

	def self.find(cid)
		super
	rescue ActiveRecord::RecordNotFound
		user = send_request query: { cid: cid }
		user.save!
		user
	end

	def self.nick(cid)
		resp = get("", query: {cid: cid, nick: 'nick'})
		if resp.success? && resp['cid'].present?
			if resp['nick'].present?
				return resp['nick']
			else
				return resp['cid']
			end
		else
			raise resp.response.inspect
		end
	end

	def nick
		@nick ||= Rails.cache.fetch "#{cid}/nick", expires_in: 14.hours do
			self.class.nick(cid)
		end
	end


	private
		def self.send_request(options)
			resp = get("", options)
			if resp.success? && resp['cid'].present?
				self.new cid: resp['cid']
			else
				raise resp.response.inspect
			end
		end
end
