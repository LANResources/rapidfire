module Rapidfire
  class SurveysController < Rapidfire::ApplicationController
    before_filter :authenticate_administrator!, except: :index
    respond_to :html, :js
    respond_to :json, only: :results

    def index
      @surveys = Survey.all
      respond_with(@surveys)
    end

    def new
      @surveys = Survey.new
      respond_with(@survey)
    end

    def create
      @survey = Survey.new(question_group_params)
      @survey.save

      respond_with(@survey, location: rapidfire.surveys_url)
    end

    def destroy
      @survey = Survey.find(params[:id])
      @survey.destroy

      respond_with(@survey)
    end

    def results
      @survey = Survey.find(params[:id])
      @survey_results =
        SurveyResults.new(survey: @survey).extract

      respond_with(@survey_results, root: false)
    end

    private
    def survey_params
      if Rails::VERSION::MAJOR == 4
        params.require(:survey).permit(:name)
      else
        params[:survey]
      end
    end
  end
end
