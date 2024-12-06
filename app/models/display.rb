class Display < ApplicationRecord
  belongs_to :display_type
  belongs_to :user, optional: true

  validates :sort, :time, presence: { message: 'を入力してください' }
  validates :option, length: { maximum: 90, message: '：90文字以内で入力して下さい' }
  validates :note, length: { maximum: 300, message: '：300文字以内で入力して下さい' }
  validates :sort, numericality: { only_integer: true, message: '：整数で入力して下さい' }
  validates :time, numericality: { message: '：数字で入力して下さい' }
  validate :file_upload

  scope :permission, -> (per) { includes(:display_type).where(display_type: { permission: per }) } 

  def file_upload
    unless Settings.display.allow_type.include?(filetype)
      errors.add :filetype, '許可されていない形式の画像です'
    end
    upload_path = Rails.root.join("upload", "display", display_type.name, filename)
    if File.exist?(upload_path)
      errors.add :filename, 'その名前の写真はこのディスプレイにすでに存在します'
    end
    # 無期限の画像を1枚は要求
    if limit.present? && !Display.where(display_type_id: display_type).not(limit: nil).exists?
      errors.add :limit, '無期限の写真を1枚以上登録する必要があります'
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    ["name", "filename", "limit", "display_type_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
