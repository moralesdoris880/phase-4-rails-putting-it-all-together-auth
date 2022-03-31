class RecipesController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
    before_action :authorized
    def index
        user = User.find_by(id:session[:user_id])
        if user
            render json: Recipe.all,include: [:user], status: :created
        else
            render json: {errors: ['Not found']}, status: :unauthorized
        end
    end

    def create
        user = User.find_by(id:session[:user_id])
        if user
            recipe = user.recipes.create!(recipe_params)
            if recipe
                render json: recipe, include: [:user], status: :created
            else
                render_unprocessable_entity
            end
        else
            render json: {errors: ["Not authorized"]}, status: :unauthorized
        end
    end

    private

    def recipe_params
        params.permit(:title,:instructions,:minutes_to_complete,:user_id)
    end

    def render_unprocessable_entity(invalid)
        render json: { errors: ["Incorrect"]}, status: :unprocessable_entity
    end

end
