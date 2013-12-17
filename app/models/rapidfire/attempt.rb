module Rapidfire
  class Attempt < ActiveRecord::Base
    belongs_to :survey
    belongs_to :user
    has_many   :answers, inverse_of: :attempt, autosave: true, dependent: :destroy
    has_many  :questions, through: :answers

    COMPLETED_FOR_OPTIONS = ['Stop ACT', 'Drug Free Communities']

    validates_presence_of :activity_date, :description
    before_save :set_default_completed_for

    if Rails::VERSION::MAJOR == 3
      attr_accessible :survey, :user
    end

    private

    def set_default_completed_for
      self.completed_for ||= []
    end
  end
end
