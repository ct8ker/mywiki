#
# Application controller
#
class ApplicationController < ActionController::Base

  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception

  helper_method :markdown

  #
  # Parse markdown text
  #
  def markdown(text)
    options = {
        filter_html:     true,
        hard_wrap:       true,
        link_attributes: { rel: 'nofollow' }
    }
    renderer = HTMLRenderer.new(options)
    extensions = {
        autolink:           true,
        fenced_code_blocks: true,
        lax_spacing:        true,
        no_intra_emphasis:  true,
        strikethrough:      true,
        superscript:        true,
        tables:             true
    }
    Redcarpet::Markdown.new(renderer, extensions).render(text).html_safe
  end

  rescue_from ActiveRecord::RecordNotFound,         with: :error_404
  rescue_from ActionController::UnknownController,  with: :error_404
  rescue_from ActionController::RoutingError,       with: :error_404
  rescue_from Exception,                            with: :error_500

  #
  # 404 error page
  #
  def error_404
    render template: 'errors/404', status: 404, layout: 'error'
  end

  #
  # 500 error page
  #
  def error_500
    render template: 'errors/500', status: 500, layout: 'error'
  end

  protected

  # HTMLRenderer
  class HTMLRenderer < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet
    def block_code(code, language)
      Rouge.highlight(code, language || 'text', 'html')
    end
  end

  # Customize devise strong parameter
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:login_id, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login_id, :password, :password_confirmation, :remember_me) }
  end
end
