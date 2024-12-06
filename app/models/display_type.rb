class DisplayType < ApplicationRecord
  has_many :display

  validates :name, :permission, :target_path, presence: { message: 'を入力してください' }
  validates :name, length: { maximum: 20, message: '：20文字以内で入力して下さい' }
  validates :target_path, length: { maximum: 90, message: '：90文字以内で入力して下さい' }
  validates :note, length: { maximum: 300, message: '：300文字以内で入力して下さい' }
  validates :name, uniqueness: {message: '：すでに存在している種別名です'}

  def self.ransackable_attributes(auth_object = nil)
    ["name", "permission"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
