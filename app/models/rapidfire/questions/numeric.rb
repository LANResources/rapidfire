module Rapidfire
  module Questions
    class Numeric < Rapidfire::Question
      def validate_answer(answer)
        super(answer)

        if rules[:presence] == "1" || answer.answer_text.present?
          validation_options = {}
          if rules[:greater_than_or_equal_to].present?
            validation_options[:greater_than_or_equal_to] = rules[:greater_than_or_equal_to].to_i
          end
          if rules[:less_than_or_equal_to].present?
            validation_options[:less_than_or_equal_to] = rules[:less_than_or_equal_to].to_i
          end
          if rules[:only_integer].present? && rules[:only_integer] == "1"
            validation_options[:only_integer] = true
          end

          answer.validates_numericality_of :answer_text, validation_options
        end
      end
    end
  end
end
