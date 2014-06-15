#
# Article model
#
class Article < ActiveRecord::Base

  has_and_belongs_to_many :tags
  belongs_to              :user

  PRIVATE = 1
  PUBLIC  = 0

  validates :title,   presence: true, uniqueness: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 65535 }
  validates :private, inclusion: { in: PUBLIC..PRIVATE }

  #
  # Find article by title
  #
  def self.find_by_title(title, options = {})
    article_table = Article.arel_table
    conditions = article_table[:title].eq(title).and(article_table[:private].eq(PUBLIC))

    if options[:user_id].present?
      conditions = conditions.or(article_table[:title].eq(title).and(article_table[:user_id].eq(options[:user_id])))
    end

    article = where(conditions).first
    unless article
      raise ActiveRecord::RecordNotFound
    end
    article
  end

end
