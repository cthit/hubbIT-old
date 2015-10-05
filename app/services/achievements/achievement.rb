require_relative './achievement_api_service'

class Achievement

	attr_accessor :name, :code

	def initialize(name, code, icon="", description="", category="", points=1)
		@name = name
		@code = code
		@icon = icon
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
		AchievementApiService.unlock_achievement user.id, @code
	end

	def achieved? user
		false
	end

	def execute user
		self.unlock user if self.achieved? user
	end

end
