module SessionsHelper

  def map_users_to_groups(list_of_users_with_groups)
    users = list_of_users_with_groups.map {|user| User.find user}
    groups = {}

    users.each do |user|
      user.groups.each do |group|
        if group.isActive
          name = group.name.gsub(/\(*[0-9]/, '').to_sym
          print(name)
          groups[name].present? ? groups[name] << user : groups[name] = [user]
        end
      end
    end

    groups.select {|g| User::ALLOWED_GROUPS.include? g}
  end
end
