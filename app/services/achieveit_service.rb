class AchieveITService
	include HTTParty

	BASE_URL = "localhost:3000/"
	ACHIEVEMENT_URL = BASE_URL + "/achievements.json"

	def self.derp
		p "derp"
		return "herp"
	end

	def self.submit_achievement()
    	body = { 
    			:name => "Test with json-post",
				:icon => "http://img10.deviantart.net/7182/i/2012/154/e/1/ninja_saga_achievement_logo_by_philip98-d523i2b.png",
				:desc => "This is a nice description",
				:provider => "TestIT",
				:category => "Famous",
				:points => 15
             }
        p AchieveITService.submit(ACHIEVEMENT_URL, body)
    end






   private

   	def self.submit(url, body)
   		HTTParty.post(url, 
    	:body => body.to_json,
        :headers => { 'Content-Type' => 'application/json' } )
    end
end