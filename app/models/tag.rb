#
# Tag model
#
class Tag < ActiveRecord::Base

  has_and_belongs_to_many :articles

  validates :name, presence: true, uniqueness: true, length: { maximum: 30 }

  #
  # Find tag by name
  #
  def self.find_by_name(name)
    where(name: name).first
  end
end
