Rails.application.routes.draw do

  # Root
  root        'welcome#index'

  # Devise
  devise_for  :users

  # Articles
  get         'wiki/:title', controller: :articles, action: :show
  post        'articles/preview', controller: :articles, action: :preview
  resources   :articles, only: ['new', 'create', 'edit', 'update']

  # Tags
  get         'tags/:name/articles', controller: :tags, action: :show
  resources   :tags, only: ['index', 'new', 'create', 'edit', 'update', 'destroy']

  # Not found
  get '*path', controller: 'application', action: 'error_404'

end
