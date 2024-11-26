class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :reward_content

  validates :name, :display, :permission, presence: { message: 'を入力してください' }
  validates :name, :display, length: { maximum: 16, message: '：16文字以内で入力して下さい' }
  validates :name, uniqueness: {message: '：すでに存在しているログインIDです'}

  def self.ransackable_attributes(auth_object = nil)
    ["display", "id", "name", "permission"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
