class CreateContentTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :content_types do |t|
      t.string :name, null: false
      t.text :note

      t.timestamps
    end
  end
end
