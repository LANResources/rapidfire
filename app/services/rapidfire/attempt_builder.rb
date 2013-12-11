module Rapidfire
  class AttemptBuilder < Rapidfire::BaseService
    attr_accessor :user, :survey, :questions, :answers, :params

    def initialize(params = {})
      super(params)
      build_attempt
    end

    def to_model
      @attempt
    end

    def save!(options = {})
      params.each do |question_id, answer_attributes|
        if answer = @attempt.answers.find { |a| a.question_id.to_s == question_id.to_s }
          text = answer_attributes[:answer_text]
          answer.answer_text =
            text.is_a?(Array) ? strip_checkbox_answers(text).join(',') : text
        end
      end

      @attempt.save!(options)
    end

    def save(options = {})
      save!(options)
    rescue Exception => e
      # repopulate answers here in case of failure as they are not getting updated
      @answers = @survey.questions.collect do |question|
        @attempt.answers.find { |a| a.question_id == question.id }
      end
      false
    end

    private
    def build_attempt
      @attempt = Attempt.new(user: user, survey: survey)
      @answers = @survey.questions.collect do |question|
        @attempt.answers.build(question_id: question.id)
      end
    end

    def strip_checkbox_answers(text)
      text.reject(&:blank?).reject { |t| t == "0" }
    end
  end
end