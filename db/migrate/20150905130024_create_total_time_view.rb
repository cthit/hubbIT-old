class CreateTotalTimeView < ActiveRecord::Migration
  def self.up
    execute <<-SQL
      CREATE VIEW users_total_time AS
      SELECT `id`, `user_id`, SUM(TIMESTAMPDIFF(SECOND, `start_time`, `end_time`)) as `total_time`
      FROM user_sessions GROUP BY `user_id` ORDER BY `total_time` DESC
    SQL
  end

  def self.down
    execute <<-SQL
      DROP VIEW users_total_time;
    SQL
  end
end
