module Rapidfire
  class SurveysController < Rapidfire::ApplicationController
    respond_to :html, :js
    respond_to :json, only: :results

    def index
      @surveys = Survey.all
      authorize! @surveys
      respond_with(@surveys)
    end

    def new
      @survey = Survey.new
      authorize! @survey
      respond_with(@survey)
    end

    def create
      @survey = Survey.new(survey_params)
      authorize! @survey
      @survey.save

      respond_with(@survey, location: rapidfire.surveys_url)
    end

    def destroy
      @survey = Survey.find(params[:id])
      authorize! @survey
      @survey.destroy

      respond_with(@survey)
    end

    def results
      @survey = Survey.find(params[:id])
      @survey_results = SurveyResults.new(survey: @survey).extract

      respond_with(@survey_results, root: false)
    end

    private
    def survey_params
      if Rails::VERSION::MAJOR == 4
        params.require(:survey).permit *policy(@survey || Rapidfire::Survey).permitted_attributes
      else
        params[:survey]
      end
    end
  end
end
