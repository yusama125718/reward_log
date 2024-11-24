class ContentType < ApplicationRecord
  has_many :reward_content

  validates :name, presence: { message: 'を入力してください' }
  validates :name, length: { maximum: 20, message: '：20文字以内で入力して下さい' }
  validates :note, length: { maximum: 300, message: '：20文字以内で入力して下さい' }
  validates :name, uniqueness: {message: '：すでに存在している種別名です'}
  validates :state, inclusion: { in: [true, false], message: '：値が不正です' }

  def self.ransackable_attributes(auth_object = nil)
    ["name", "state"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
