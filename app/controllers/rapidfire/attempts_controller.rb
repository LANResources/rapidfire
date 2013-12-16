module Rapidfire
  class AttemptsController < Rapidfire::ApplicationController
    before_filter :find_survey!, only: [:new, :create]
    before_filter :find_attempt!, only: [:show, :edit, :update, :destroy]

    def index
      @attempts = Attempt.where(user_id: current_user.id)
    end

    def new
      @attempt_builder = AttemptBuilder.new(attempt_params)
    end

    def create
      p = attempt_params
      Rails.logger.info p
      @attempt_builder = AttemptBuilder.new(p)

      if @attempt_builder.save
        redirect_to surveys_path
      else
        render :new
      end
    end

    def show
    end

    def edit
    end

    def update
    end

    def destroy
    end

    private
    def find_survey!
      if params[:survey_id]
        @survey = Survey.find(params[:survey_id])
      else
        @survey = Survey.active.last
      end
    end

    def find_attempt!
      @attempt = Attempt.find(params[:id])
    end

    def attempt_params
      { 
        params: params[:attempt],
        user: current_user, 
        survey: @survey, 
        description: params[:description], 
        completed_for: params[:completed_for], 
        activity_date: params[:activity_date]
      }
    end
  end
end
