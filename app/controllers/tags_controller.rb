#
# Tags controller
#
class TagsController < ApplicationController

  before_filter :authenticate_user!, except: [:index]

  #
  # Tag index
  #
  def index
    @tags = Tag.all
  end

  #
  # New tag (Ajax)
  #
  def new
    if request.xhr?
      @tag = Tag.new
      html = render_to_string partial: 'new'
      render json: {html: html}
    end
  end

  #
  # Edit tag (Ajax)
  #
  def edit
    if request.xhr?
      @tag = Tag.find(params[:id])
      html = render_to_string partial: 'edit'
      render json: {html: html}
    end
  end

  #
  # Create tag (Ajax)
  #
  def create
    if request.xhr?
      tag = Tag.new(tag_params)

      unless tag.valid?
        errors = {}
        tag.errors.messages.each {|k, v| errors[k] = tag.errors.full_messages_for(k)}
        render json: {errors: errors}, status: 422 and return
      end

      Tag.transaction do
        tag.save
      end

      render json: {tag: tag}, status: 200
    end
  end

  #
  # Update tag (Ajax)
  #
  def update
    if request.xhr?
      tag = Tag.find(params[:id])
      tag.attributes = tag_params

      unless tag.valid?
        errors = {}
        tag.errors.messages.each {|k, v| errors[k] = tag.errors.full_messages_for(k)}
        render json: {errors: errors}, status: 422 and return
      end

      stale_object_error = false
      begin
        Tag.transaction do
          tag.save
        end
      rescue ActiveRecord::StaleObjectError
        stale_object_error = true
      end

      if stale_object_error
        errors = {stale_object_error: ['Tag is already modified by others.']}
        render json: {errors: errors}, status: 422
      else
        render json: {}, status: 200
      end
    end
  end

  #
  # Destroy tag (Ajax)
  #
  def destroy
    if request.xhr?
      tag = Tag.find(params[:id])

      stale_object_error = false
      begin
        Tag.transaction do
          tag.destroy
        end
      rescue ActiveRecord::StaleObjectError
        stale_object_error = true
      end

      if stale_object_error
        errors = {stale_object_error: ['Tag is already modified by others.']}
        render json: {errors: errors}, status: 422
      else
        render json: {}, status: 200
      end
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:name, :lock_version)
  end
end