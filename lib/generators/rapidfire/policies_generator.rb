# inspired by devise and forem
require 'rails/generators'

module Rapidfire
  module Generators
    class PoliciesGenerator < Rails::Generators::Base
      source_root File.expand_path("../../../../app/policies/rapidfire", __FILE__)
      desc "Copies default Rapidfire Pundit policies to your application."

      def copy_views
        policy_directory :attempts
        policy_directory :answers
        policy_directory :surveys
        policy_directory :questions
      end

      protected
      def policy_directory(name)
        directory name.to_s, "app/policies/rapidfire/#{name}"
      end
    end
  end
end
