class CreateDisplayTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :display_types do |t|
      t.string :name, null: false
      t.string :target_path
      t.string :permission
      t.text :note

      t.timestamps
    end
  end
end
