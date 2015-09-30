class AchieveITService
	include HTTParty

	base_uri "http://localhost:3001"
	ACHIEVEMENT_URI = "/achievements.json"
	UNLOCK_URI = "/unlocks.json"
	PROVIDER_NAME = "hubbit"

	def self.derp
		p "derp"
		return "herp"
	end

	def self.submit_achievement(name, icon="", description="", category="", points=1)
    	body = { 
    			:name => name,
				:icon => icon,
				:desc => description,
				:provider => PROVIDER_NAME,
				:category => category,
				:points => points
             }

        AchieveITService.submit(ACHIEVEMENT_URI, body)
    end

    def self.unlock_achievement(cid, achievement)
    	body = {
    		:cid => cid,
    		:achievement => achievement
    	}
    	p body

    	AchieveITService.submit(UNLOCK_URI, body)
    end



   private

   	def self.submit(uri, body)
   		post(uri, 
    	:body => body.to_json,
        :headers => { 'Content-Type' => 'application/json' } )
    end
end