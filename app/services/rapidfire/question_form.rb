module Rapidfire
  class QuestionForm < Rapidfire::BaseService
    AVAILABLE_QUESTIONS =
      [
       Rapidfire::Questions::Checkbox,
       Rapidfire::Questions::Date,
       Rapidfire::Questions::Long,
       Rapidfire::Questions::Numeric,
       Rapidfire::Questions::Radio,
       Rapidfire::Questions::Select,
       Rapidfire::Questions::MultiSelect,
       Rapidfire::Questions::Short,
       Rapidfire::Questions::UserMultiSelect,
       Rapidfire::Questions::SectorCheckbox
      ]

    QUESTION_TYPES = AVAILABLE_QUESTIONS.inject({}) do |result, question|
      question_name = question.to_s.split("::").last
      result[question_name] = question.to_s
      result
    end

    attr_accessor :survey, :question, :type, :question_text, :answer_options,
      :help_text, :allow_custom, :follow_up_for_id, :follow_up_for_condition,
      :answer_presence, :answer_minimum_length, :answer_maximum_length,
      :answer_greater_than_or_equal_to, :answer_less_than_or_equal_to, :section

    delegate :valid?, :errors, :id, :to => :question

    def to_model
      question
    end

    def initialize(params = {})
      from_question_to_attributes(params[:question]) if params[:question]
      super(params)
      @question ||= survey.questions.new
    end

    def save
      @question.new_record? ? create_question : update_question
    end

    private
    def create_question
      klass = nil
      if QUESTION_TYPES.values.include?(type)
        klass = type.constantize
      else
        errors.add(:type, :invalid)
        return false
      end

      @question = klass.create(to_question_params)
    end

    def update_question
      @question.update_attributes(to_question_params)
    end

    def to_question_params
      {
        :survey => survey,
        :section  => section,
        :type => type,
        :question_text  => question_text,
        :answer_options => answer_options,
        :help_text => help_text,
        :allow_custom => allow_custom,
        :follow_up_for_id => follow_up_for_id,
        :follow_up_for_condition => follow_up_for_condition,
        :validation_rules => {
          :presence => answer_presence,
          :minimum  => answer_minimum_length,
          :maximum  => answer_maximum_length,
          :greater_than_or_equal_to => answer_greater_than_or_equal_to,
          :less_than_or_equal_to    => answer_less_than_or_equal_to
        }
      }
    end

    def from_question_to_attributes(question)
      self.type = question.type
      self.survey  = question.survey
      self.section   = question.section
      self.question_text   = question.question_text
      self.answer_options  = question.answer_options
      self.help_text  = question.help_text
      self.allow_custom  = question.allow_custom
      self.follow_up_for_id  = question.follow_up_for_id
      self.follow_up_for_condition  = question.follow_up_for_condition
      self.answer_presence = question.rules[:presence]
      self.answer_minimum_length = question.rules[:minimum]
      self.answer_maximum_length = question.rules[:maximum]
      self.answer_greater_than_or_equal_to = question.rules[:greater_than_or_equal_to]
      self.answer_less_than_or_equal_to    = question.rules[:less_than_or_equal_to]
    end
  end
end
