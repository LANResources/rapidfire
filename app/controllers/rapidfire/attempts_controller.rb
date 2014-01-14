module Rapidfire
  class AttemptsController < Rapidfire::ApplicationController
    before_filter :find_survey!, only: [:new, :create]
    before_filter :find_attempt!, only: [:show, :edit, :update, :destroy]
    before_filter :scope_attempts, only: :index

    def index
    end

    def new
      @attempt_builder = AttemptBuilder.new(attempt_params)
    end

    def create
      @attempt_builder = AttemptBuilder.new(attempt_params)

      if @attempt_builder.save
        redirect_to activity_path(@attempt_builder.attempt)
      else
        render :new
      end
    end

    def show
    end

    def edit
      @survey = @attempt.survey
      @attempt_builder = AttemptBuilder.build @attempt
    end

    def update
      @survey = @attempt.survey
      @attempt_builder = AttemptBuilder.build_for_update @attempt, attempt_params

      if @attempt_builder.save
        redirect_to activity_path(@attempt)
      else
        render :edit
      end
    end

    def destroy
      authorize! @attempt
      @attempt.destroy
      redirect_to activities_path
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
        activity_date: params[:activity_date],
        activity_type: params[:activity_type]
      }
    end

    def scope_attempts
      @scopes = {}
      @scope_params = {}
      @attempts = Attempt.includes(:user)
      if params[:for]
        @scopes[:for] = "for #{params[:for]}"
        @scope_params[:for] = params[:for]
        @attempts = @attempts.where "'#{params[:for]}' = ANY (completed_for)"
      end
      if params[:user] and User.exists?(params[:user])
        @scopes[:user] = "by #{User.find(params[:user]).full_name}"
        @scope_params[:user] = params[:user]
        @attempts = @attempts.where user_id: params[:user]
      end
      @attempts = @attempts.order("#{sort_column} #{sort_direction}").page(params[:page]).per_page(20)
    end

    def sort_column
      super(Attempt.column_names + ['users.last_name'], 'updated_at')
    end
  end
end
