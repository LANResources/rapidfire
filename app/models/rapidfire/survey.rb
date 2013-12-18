module Rapidfire
  class Survey < ActiveRecord::Base
    has_many  :questions, -> { order('section ASC, position ASC') }, dependent: :destroy
    has_many  :attempts, dependent: :destroy

    acts_as_list

    validates :name, :presence => true

    scope :active, -> { where(active: true) }

    SECTION_ORDERING = ['Impact', ]
    if Rails::VERSION::MAJOR == 3
      attr_accessible :name
    end

    def sections
      s = questions.map(&:section).uniq.compact
      s.any? ? s : nil
    end
  end
end
