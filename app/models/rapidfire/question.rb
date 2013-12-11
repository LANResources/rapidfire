module Rapidfire
  class Question < ActiveRecord::Base
    belongs_to :survey, inverse_of: :questions
    has_many   :answers
    has_many :follow_up_questions, class_name: "Question", foreign_key: "follow_up_for_id", dependent: :destroy
    belongs_to :follow_up_for, class_name: "Question", foreign_key: "follow_up_for_id", touch: true

    acts_as_list scope: :survey

    validates :survey, :question_text, presence: true
    serialize :validation_rules

    scope :with_choices, -> { where(type: ['Checkbox', 'Radio', 'Select', 'MultiSelect'].map{|t| "Rapidfire::Questions::#{t}"}) }

    if Rails::VERSION::MAJOR == 3
      attr_accessible :survey, :question_text, :validation_rules, :answer_options, :follow_up_for_id, :follow_up_for_condition, :allow_custom, :help_text
    end

    def self.inherited(child)
      child.instance_eval do
        def model_name
          Question.model_name
        end
      end

      super
    end

    def rules
      validation_rules || {}
    end

    # answer will delegate its validation to question, and question
    # will inturn add validations on answer on the fly!
    def validate_answer(answer)
      if rules[:presence] == "1"
        answer.validates_presence_of :answer_text
      end

      if rules[:minimum].present? || rules[:maximum].present?
        min_max = { minimum: rules[:minimum].to_i }
        min_max[:maximum] = rules[:maximum].to_i if rules[:maximum].present?

        answer.validates_length_of :answer_text, min_max
      end
    end
  end
end
