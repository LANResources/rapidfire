module Rapidfire
  module Questions
    class UserMultiSelect < Rapidfire::Question
      def grouped_options
        Organization.order(:name)
      end

      def options
        User.all
      end

      def validate_answer(answer)
        super(answer)

        if rules[:presence] == "1" || answer.answer_text.present?
          answer.answer_text.split(",,,").each do |value|
            answer.errors.add(:answer_text, :invalid) unless User.exists? value
          end
        end
      end
    end
  end
end
