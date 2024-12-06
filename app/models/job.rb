class Job < ApplicationRecord
  has_many :reward_content

  validates :name, presence: { message: 'を入力してください' }
  validates :name, length: { maximum: 20, message: '：20文字以内で入力して下さい' }
  validates :note, length: { maximum: 300, message: '：300文字以内で入力して下さい' }
  validates :name, uniqueness: {message: '：すでに存在している仕事名です'}

  def self.ransackable_attributes(auth_object = nil)
    ["name", "note"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
