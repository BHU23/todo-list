class AddEmailToTasks < ActiveRecord::Migration[7.2]
  def change
    add_column :tasks, :email, :string
  end
end
