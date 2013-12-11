module Rapidfire
  class Survey < ActiveRecord::Base
    has_many  :questions, -> { order('position ASC') }
    acts_as_list

    validates :name, :presence => true

    if Rails::VERSION::MAJOR == 3
      attr_accessible :name
    end
  end
end
