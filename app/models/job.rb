class Job < ActiveRecord::Base
  validates :title, :company, :description, :user_id, presence: true
  belongs_to :user
  has_many :comments, order: 'created_at DESC', dependent: :destroy
  
  self.per_page = 25
end
