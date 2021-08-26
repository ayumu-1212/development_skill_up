class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_variable, only: [:show, :index]
  before_action :identity_verification, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @books = @user.books
  end

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "You have updated user successfully."
      redirect_to user_path(@user)
    else
      render :edit
    end
  end


  def set_variable
    @new_book = Book.new
    @user = current_user
  end

  def identity_verification
    if current_user.id != params[:id].to_i
      redirect_to user_path(current_user.id)
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

end
