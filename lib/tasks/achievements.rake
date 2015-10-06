namespace 'HubbIT' do
	task hourly: :environment do
		check_achievements 'hourly'
	end
	task daily: :environment do 
		check_achievements 'daily'
	end
end 

def check_achievements(scope)
	puts 'Checking: ' + scope + '...'
	achievements = load_achievement_files scope
	achievements.each do |achievement|
		puts ' ' + achievement.name
		User.all.each do |user|
			achievement.execute user
		end
		puts ' end of ' + achievement.name
	end
	puts 'Done with: ' + scope
end

def load_achievement_files(dir)
	Dir[Rails.root.join('app', 'services', 'achievements', dir, '*.rb')].map do |file|
		require file
		file_name = File.basename(file, '.rb')
		file_name.camelcase.constantize.new
	end
end
