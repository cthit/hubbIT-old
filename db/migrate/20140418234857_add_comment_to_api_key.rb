class AddCommentToApiKey < ActiveRecord::Migration
  def change
    add_column :api_keys, :comment, :string
  end
end
