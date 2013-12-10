module Rapidfire
  class QuestionsController < Rapidfire::ApplicationController
    before_filter :authenticate_administrator!
    respond_to :html, :js

    before_filter :find_survey!
    before_filter :find_question!, :only => [:edit, :update, :destroy]

    def index
      @questions = @survey.questions
      respond_with(@questions)
    end

    def new
      @question = QuestionForm.new(survey: @survey)
      respond_with(@question)
    end

    def create
      form_params = params[:question].merge(survey: @survey)
      @question = QuestionForm.new(form_params)
      @question.save

      respond_with(@question, location: index_location)
    end

    def edit
      @question = QuestionForm.new(question: @question)
      respond_with(@question)
    end

    def update
      form_params = params[:question].merge(question: @question)
      @question = QuestionForm.new(form_params)
      @question.save

      respond_with(@question, location: index_location)
    end

    def destroy
      @question.destroy
      respond_with(@question, location: index_location)
    end

    private
    def find_survey!
      @survey = Survey.find(params[:survey_id])
    end

    def find_question!
      @question = @survey.questions.find(params[:id])
    end

    def index_location
      rapidfire.survey_questions_url(@survey)
    end
  end
end
