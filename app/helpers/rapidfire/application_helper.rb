module Rapidfire
  module ApplicationHelper
    def render_answer_form_helper(answer, form)
      partial = answer.question.type.to_s.split("::").last.underscore
      render partial: "rapidfire/answers/#{partial}", locals: { f: form, answer: answer }
    end

    def checkbox_checked?(answer, option)
      answer.answer_text.to_s.split(",").include?(option)
    end

    def display_answer_text(answer)
      case answer.question.type.split('::').last
      when 'SectorCheckbox'
        Sector.where(id: answer.answer_text.split(',').map(&:to_i)).map do |s|
          s.name
        end.join('<br/>')
      when 'UserMultiSelect'
        User.where(id: answer.answer_text.split(',')).map do |user|
          link_to user.full_name, user, class: 'btn-link'
        end.join('<br/>')
      when 'Checkbox'
        answer.answer_text.sub ',', '<br/>'
      else
        answer.answer_text
      end.html_safe
    end

    def method_missing(method, *args, &block)
      if method.to_s.end_with?('_path') or method.to_s.end_with?('_url')
        if main_app.respond_to?(method)
          main_app.send(method, *args)
        else
          super
        end
      else
        super
      end
    end

    def respond_to?(method)
      if method.to_s.end_with?('_path') or method.to_s.end_with?('_url')
        if main_app.respond_to?(method)
          true
        else
          super
        end
      else
        super
      end
    end
  end
end
