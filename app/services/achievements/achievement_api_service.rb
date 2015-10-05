class AchievementApiService
	include HTTParty

	base_uri "http://ndushi.chalmers.it:3000"
	ACHIEVEMENT_URI = "/achievements.json"
	UNLOCK_URI = "/unlocks.json"
    API_TOKEN = "f6f804ba8bd4247bca6e21eeaac115f7"

	def self.derp
		p "derp"
		return "herp"
	end

	def self.submit_achievement(name, code, icon="", description="", category="", points=1)
    	body = { 
				name: name,
                code: code,
				icon: icon,
				desc: description,
				category: category,
				points: points
             }

        AchievementApiService.submit(ACHIEVEMENT_URI, achievement: body)
    end

    def self.unlock_achievement(cid, achievement_code)
    	body = { 
			cid: cid,
			code: achievement_code
    	}

    	AchievementApiService.submit(UNLOCK_URI, unlock: body)
    end

   private

   	def self.submit(uri, body)
   		post(uri, 
            :body => body.to_json,
            :headers => { 
                'Content-Type' => 'application/json', 
                'Authorization' => 'Token ' + API_TOKEN 
            } 
        )
    end
end