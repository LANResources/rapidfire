module Rapidfire
  module Questions
    class MultiObject < Rapidfire::Question

      def multi_object?
        true
      end

      def options
        answer_options.split(/\r?\n/)
      end

      def properties
        options.map{|option| option.split('=').first }
      end

      def validate_answer(answer)
        super(answer)

        if rules[:presence] == "1" || answer.answer_text.present?
          answer.answer_text.split(";").each do |obj|
            obj.split(",").each do |value|
              prop, val = value.split('=')
              answer.errors.add(:answer_text, :invalid) unless properties.include? prop
            end
          end
        end
      end
    end
  end
end
