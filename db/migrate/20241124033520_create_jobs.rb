class CreateJobs < ActiveRecord::Migration[8.0]
  def change
    create_table :jobs do |t|
      t.string :name, null: false
      t.text :note

      t.timestamps
    end
  end
end
