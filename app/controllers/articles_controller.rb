#
# Articles controller
#
class ArticlesController < ApplicationController

  before_filter :authenticate_user!, except: [:articles, :show]

  #
  # Show article
  #
  def show
    options = {}
    if user_signed_in?
      options[:user_id] = current_user.id
    end
    @article = Article.find_by_title(params[:title], options)
  end

  #
  # New article
  #
  def new
    @article = Article.new
  end

  #
  # Edit article
  #
  def edit
    @article = current_user.articles.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @article
    render action: :new
  end

  #
  # Content preview (Ajax)
  #
  def preview
    if request.xhr?
      preview = markdown(article_params[:content])
      render json: {preview: preview}, status: 200
    end
  end

  #
  # Create article
  #
  def create
    @article = Article.new(article_params)
    @article.user = current_user
    tag_names = tag_params[:name]
    tag_names.delete("")

    if @article.valid?
      ActiveRecord::Base.transaction do
        tag_names.each do |tag_name|
          tag = Tag.find_by_name(tag_name)
          tag = Tag.new(name: tag_name) unless tag
          @article.tags << tag
        end
        @article.save
      end
      redirect_to action: 'show', title: @article.title
    else
      render action: :new
    end
  end

  #
  # Update article
  #
  def update
    @article = current_user.articles.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @article

    @article.attributes = article_params
    tag_names = tag_params[:name]
    tag_names.delete("")

    if @article.valid?
      ActiveRecord::Base.transaction do
        @article.tags.each do |tag|
          @article.tags.delete(tag) unless tag_names.include?(tag.name)
        end
        tag_names.each do |tag_name|
          tag = Tag.find_by_name(tag_name)
          tag = Tag.new(name: tag_name) unless tag
          @article.tags << tag unless @article.tags.include?(tag)
        end
        @article.save
      end
      redirect_to action: 'show', title: @article.title
    else
      render action: :edit
    end
  end

  def destroy

  end

  private

  def article_params
    params.require(:article).permit(:title, :content, :private, :lock_version)
  end

  def tag_params
    params.require(:tag).permit(name: [])
  end
end