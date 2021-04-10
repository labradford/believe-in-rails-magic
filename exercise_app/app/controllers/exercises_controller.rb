class ExercisesController < ApplicationController
  def index
    @exercises = Exercise.all
  end

  def show
    @exercise = Exercise.find(params[:id])
  end

  def new
    @exercise = Exercise.new
  end

  def create
    @exercise = Exercise.new(exercise_params)

    if @exercise.save
      redirect_to root_path
    else
      render :new
    end
  end

  private

    def exercise_params
      params.require(:exercise).permit(:activity, :description)
    end
end
