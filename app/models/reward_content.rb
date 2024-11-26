class RewardContent < ApplicationRecord
  belongs_to :content_type, optional: true
  belongs_to :job, optional: true
  belongs_to :user, optional: true

  validates :title, :worker, :amount, :confirm_date, presence: { message: 'を入力してください' }
  validates :title, length: { maximum: 20, message: '：20文字以内で入力して下さい' }
  validates :worker, length: { maximum: 16, message: '：20文字以内で入力して下さい' }
  validates :note, length: { maximum: 300, message: '：20文字以内で入力して下さい' }

  def self.ransackable_attributes(auth_object = nil)
    ["title", "amount", "worker", "note", "job_id", "content_type_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["job", "content_type"]
  end
end
