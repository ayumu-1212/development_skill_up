class FavoritesController < ApplicationController
  def create
    favorite = Favorite.new(user_id: params[:user_id], book_id: params[:book_id])
    favorite.save
    redirect_back(fallback_location: books_path)
  end

  def destroy
    if favorite = Favorite.find_by(user_id: params[:user_id], book_id: params[:book_id])
      favorite.destroy
    end
    redirect_back(fallback_location: books_path)
  end

  private
  def favorite_params
    params.require(:favorite).permit(:user_id, :book_id)
  end
end
