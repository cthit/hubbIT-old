module SessionsHelper

	def map_users_to_groups(list_of_users_with_groups)
		list_of_users_with_groups.map { |e| map_cid_to_groups(e) }
		.flatten(1)
		.reduce({}) { |acc, e| reduce_users_to_group e, acc }.select { |e| User::ALLOWED_GROUPS.include? e }
	end

	private
		def map_cid_to_groups(user_with_groups)
			user_with_groups[:groups].map { |g| [user_with_groups[:user], g.downcase.to_sym] }
		end

		def reduce_users_to_group(user_with_group, groups)
			user = user_with_group.first
			group_name = user_with_group.last
			group = groups[group_name]
			if group.present?
				group << user
			else
				group = [user]
			end
			group.uniq!
			groups[group_name] = group
			groups
		end
end
