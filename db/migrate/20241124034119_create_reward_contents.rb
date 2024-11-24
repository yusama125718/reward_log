class CreateRewardContents < ActiveRecord::Migration[8.0]
  def change
    create_table :reward_contents do |t|
      t.references :job
      t.references :content_type
      t.references :user

      t.string :title, null: false
      t.bigint :amount, default: 0
      t.text :note
      t.date :confirm_date
      t.string :worker

      t.timestamps
    end
  end
end
