class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @ordering = params[:order] || session[:order]
    @all_ratings = Movie.get_ratings()

    @selected_ratings = if not params[:ratings].nil?
      params[:ratings].keys
    elsif not session[:ratings].nil?
      session[:ratings]
    else
      @all_ratings
    end

    session[:order] = @ordering
    session[:ratings] = @selected_ratings

    if @ordering == false
      @movies = Movie.where(:rating => @selected_ratings)
    else
      @movies = Movie.order(params[:order]).where(:rating => @selected_ratings)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
