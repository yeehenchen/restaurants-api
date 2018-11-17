class Api::V1::RestaurantsController < Api::V1::BaseController
  # acts_as_token_authentication_handler_for User, except: [:index, :show]
  skip_before_action :verify_authenticity_token
  # protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  before_action :find_restaurant, only: [:show, :update, :destroy]

  def index
    @restaurants = Restaurant.all
  end

  def show
  end

  def update
    if @restaurant.update(restaurant_params)
      render :index
    else
      render_error
    end
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    if @restaurant.save
      render :show, status: :created
    else
      render_error
    end
  end

  def destroy
    @restaurant.destroy
    head :no_content
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :address, :image, :description)
  end

  def find_restaurant
    @restaurant = Restaurant.find(params[:id])
  end

  def render_error
  render json: { errors: @restaurant.errors.full_messages },
    status: :unprocessable_entity
  end
end
