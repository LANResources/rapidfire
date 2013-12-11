require 'active_model_serializers'
require 'acts_as_list'

module Rapidfire
  class Engine < ::Rails::Engine
    isolate_namespace Rapidfire
  end
end
