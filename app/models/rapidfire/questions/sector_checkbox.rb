module Rapidfire
  module Questions
    class SectorCheckbox < Rapidfire::Question
      def options
        Sector.all
      end

      def validate_answer(answer)
        super(answer)

        if rules[:presence] == "1" || answer.answer_text.present?
          answer.answer_text.split(",").each do |value|
            answer.errors.add(:answer_text, :invalid) unless Sector.exists? value
          end
        end
      end
    end
  end
end
