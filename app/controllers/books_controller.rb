class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy reserve ]
  before_action :authenticate_user!, only: [:reserve]

  # GET /books or /books.json
  def index
    # @books = Book.all
    @books = Book.paginate(page: params[:page], per_page: 60).order('created_at DESC')
    respond_to do |format|
      format.html
      format.js
    end
    # @posts = Post.paginate(:page => params[:page], :per_page => 20)
  end

  # GET /books/1 or /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books or /books.json
  def create
    @book = Book.new(book_params)
    sleep 5
    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: "Book was successfully created." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: "Book was successfully updated." }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: "Book was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def reserve
    reservation = Reservation.new(book: @book, user: current_user)
      if reservation.save!
        @msg = 'Sucessfully reserved!'
      else
        @msg = 'Reservation failed'
      end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:name, :author, :genre)
    end
end