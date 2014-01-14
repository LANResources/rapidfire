module Rapidfire
  class Attempt < ActiveRecord::Base
    belongs_to :survey
    belongs_to :user
    has_many   :answers, inverse_of: :attempt, autosave: true, dependent: :destroy
    has_many  :questions, through: :answers

    COMPLETED_FOR_OPTIONS = ['Stop ACT', 'Drug Free Communities']
    ACTIVITY_TYPE_DEFAULT_OPTIONS = ['Town Hall Meeting', 'Coalition Meeting', 'Committee Meeting', 'Alternative Drug Free Activity', 'Compliance Checks']

    validates_presence_of :activity_date, :activity_type, :description
    before_save :set_default_completed_for

    if Rails::VERSION::MAJOR == 3
      attr_accessible :survey, :user
    end

    def self.activity_types
      (ACTIVITY_TYPE_DEFAULT_OPTIONS + pluck(:activity_type).uniq.compact).uniq.sort
    end

    private

    def set_default_completed_for
      self.completed_for ||= []
    end
  end
end
