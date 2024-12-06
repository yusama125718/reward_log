class CreateDisplays < ActiveRecord::Migration[8.0]
  def change
    create_table :displays do |t|
      t.references :display_type
      t.references :user

      t.string :note
      t.string :filetype
      t.string :filename
      t.string :option
      t.float :time, null: false, default: 20.0
      t.date :limit
      t.integer :sort
      t.boolean :archive, default: false

      t.timestamps
    end
  end
end
