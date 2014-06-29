#
# Article model
#
class Article < ActiveRecord::Base

  has_and_belongs_to_many :tags
  belongs_to              :user

  enum shared_type: { open: 0, closed: 1 }

  validates :title,   presence: true, uniqueness: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 65535 }

  #
  # Find article by title
  #
  def self.find_by_title(title, options = {})
    article_table = Article.arel_table
    conditions = article_table[:title]
      .eq(title)
      .and(article_table[:shared_type].eq(shared_types[:open]))

    if options[:user_id].present?
      conditions = conditions.or(
          article_table[:title]
            .eq(title)
            .and(article_table[:user_id].eq(options[:user_id]))
      )
    end

    article = where(conditions).first
    unless article
      raise ActiveRecord::RecordNotFound
    end
    article
  end

  #
  # Search article by tag name
  #
  def self.search_by_tag(tag_id, options = {})
    article_table = Article.arel_table
    conditions = article_table[:shared_type].eq(shared_types[:open])

    if options[:user_id].present?
      conditions = conditions.or(
          article_table[:user_id].eq(options[:user_id])
      )
    end

    Article
      .includes(:user)
      .joins(:articles_tags, :user)
      .where(conditions)
      .where('articles_tags.tag_id = ?', tag_id)
      .order('articles.created_at desc').limit(10).load
  end

end
