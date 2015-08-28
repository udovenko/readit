Readit::Engine.routes.draw do
  post '/announcements/:id/store_reviewed', to: 'announcements#store_reviewed', as: 'store_reviewed_announcement'
end
