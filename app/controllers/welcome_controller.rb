#
# Welcome controller
#
class WelcomeController < ApplicationController

  #
  # Top page
  #
  def index
    @article = Article.where(title: 'About').first
  end
end