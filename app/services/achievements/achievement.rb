require_relative './achievement_api_service'

class Achievement

	attr_accessor :name, :code

	def initialize(name, code, description="", category="", points=1)
		@name = name
		@code = code
		@icon = "/achievements/#{code}.svg"
		@description = description
		@category = category
		@points = points
		self.submit
	end

	def submit
		AchievementApiService.submit_achievement @name, @code, @icon, @description, @category, @points
	end

	def unlock user
		puts "Unlocking #{@name} for #{user.cid}"
		AchievementApiService.unlock_achievement user.cid, @code
	end

	def achieved? user
		false
	end

	def execute user
		self.unlock user if self.achieved? user
	end

end
