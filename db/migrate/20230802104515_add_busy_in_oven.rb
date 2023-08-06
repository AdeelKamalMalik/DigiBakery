class AddBusyInOven < ActiveRecord::Migration[7.0]
  def change
    add_column :ovens, :busy, :boolean, default: false
  end
end
