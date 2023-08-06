class AddStateInCookies < ActiveRecord::Migration[7.0]
  def change
    add_column :cookies, :state, :integer, default: 0
  end
end
