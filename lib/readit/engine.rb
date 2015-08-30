module Readit
  class Engine < ::Rails::Engine
    require 'bootstrap-sass' if Rails.env.development? || Rails.env.test?
    isolate_namespace Readit
  end
end
