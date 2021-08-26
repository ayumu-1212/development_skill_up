class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_variable, only: [:index, :show]
  before_action :identity_verification, only: [:edit, :update, :destroy]

  def index
    @books = Book.all
    @book_comment = BookComment.new
  end

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @book_comment = BookComment.new
    @book_comments = @book.book_comments
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "You have updated book successfully."
      redirect_to book_path(@book)
    else
      render :edit
    end
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book)
    else
      @books = Book.all
      @user = current_user
      @new_book = @book
      render :index
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  def set_variable
    @new_book = Book.new
    @user = current_user
  end

  def identity_verification
    book = Book.find(params[:id])
    if current_user.id != book.user.id
      redirect_to books_path
    end
  end

  private
  def book_params
    params.require(:book).permit(:title, :body, :user_id)
  end
end
