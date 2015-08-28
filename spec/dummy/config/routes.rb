Rails.application.routes.draw do
  root 'landing#index'
  mount Readit::Engine => '/readit'
end
