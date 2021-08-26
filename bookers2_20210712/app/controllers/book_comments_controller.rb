class BookCommentsController < ApplicationController
  def create
    @book_comment = BookComment.new(book_comment_params)
    @book_comment.book_id = params[:book_id]
    @book_comment.user_id = params[:user_id]
    if @book_comment.save
      redirect_to book_path(@book_comment.book_id)
    else
      @new_book = Book.new
      @book = Book.find(params[:book_id])
      @user = @book.user
      render "books/show"
    end
  end

  def destroy
    book_comment = BookComment.find_by(book_id: params[:book_id], user_id: params[:user_id])
    book_comment.destroy
    redirect_to book_path(params[:book_id])
  end

  private
  def book_comment_params
    params.require(:book_comment).permit(:user_id, :book_id, :body)
  end
end
