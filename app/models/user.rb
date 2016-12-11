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
	has_one :users_total_time, class_name: UsersTotalTime

	scope :with_total_time, -> { select('users.*', 'total_time').joins(:users_total_time).where('total_time IS NOT NULL').order('users_total_time.total_time desc') }

	delegate :ranking, to: :users_total_time

	ALLOWED_GROUPS = [:styrit, :snit, :sexit, :prit, :nollkit, :armit, :digit, :fanbarerit, :fritid, :'8bit', :drawit, :flashit, :hookit, :revisorer, :valberedningen, :laggit]

	self.primary_key = :cid

	base_uri "https://account.chalmers.it/userInfo.php"

	accepts_nested_attributes_for :devices, allow_destroy: true

	def self.find_by_token(token)
		fetch_user token: token
	end

	def self.find(cid)
		super
	rescue ActiveRecord::RecordNotFound
		user = fetch_user cid: cid
		user.save!
		user
	end

	def nick
		@nick ||= Rails.cache.fetch "#{cid}/nick", expires_in: 24.hours do
			resp = self.class.send_request(query: { cid: cid })
			if resp['nick'].present?
				resp['nick']
			else
				cid
			end
		end
	end

	def groups
		@groups ||= Rails.cache.fetch "#{cid}/groups", expires_in: 24.hours do
			resp = self.class.send_request(query: { cid: cid })
			if resp['groups'].present?
				resp['groups']
			else
				[]
			end
		end
	end

	private
		def self.fetch_user(options)
			User.find_or_create_by(cid: send_request(query: options)['cid'])
		end

		def self.send_request(options)
			resp = get("", options)
			if resp.success? && resp['cid'].present?
				resp
			else
				raise SecurityError, resp['error']
			end
		end
end

class Symbol
	def itize
		case self
			when :digit, :styrit, :sexit, :fritid, :snit
				self.to_s.gsub /it/, 'IT'
			when :drawit, :armit, :hookit, :flashit, :laggit
				self.to_s.titleize.gsub /it/, 'IT'
			when :'8bit'
				'8-bIT'
			when :nollkit
				'NollKIT'
			when :prit
				'P.R.I.T.'
			when :fanbarerit
				'FanbärerIT'
			when :valberedningen
				'Valberedningen'
			else
				self.to_s
		end
	end
end
