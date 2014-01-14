module Rapidfire
  class QuestionsController < Rapidfire::ApplicationController
    respond_to :html, :js

    before_filter :find_survey!
    before_filter :find_question!, :only => [:edit, :update, :destroy]

    def index
      @questions = @survey.questions
      authorize! @questions
      respond_with(@questions)
    end

    def show
      @question = Question.find(params[:id])
      respond_to do |format|
        format.json { render json: @question }
      end
    end

    def new
      @question = QuestionForm.new(survey: @survey)
      authorize! @question.to_model
      respond_with(@question)
    end

    def create
      form_params = question_params.merge(survey: @survey)
      @question = QuestionForm.new(form_params)
      authorize! @question.to_model
      @question.save

      respond_with(@question, location: index_location)
    end

    def edit
      @question = QuestionForm.new(question: @question)
      authorize! @question.to_model
      respond_with(@question)
    end

    def update
      form_params = question_params.merge(question: @question)
      @question = QuestionForm.new(form_params)
      authorize! @question.to_model
      @question.save

      respond_with(@question, location: index_location)
    end

    def destroy
      authorize! @question
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

    def question_params
      if Rails::VERSION::MAJOR == 4
        params.require(:question).permit *policy(@question || Rapidfire::Question).permitted_attributes
      else
        params[:question]
      end
    end
  end
end
