class MoviesController < ApplicationController

  def show
    id = params[:id]
    @movie = Movie.find(id) 
  end

  def index
    @all_ratings = Movie.all_ratings

    if (params[:sort].blank? && params[:ratings].blank?) && (session[:sort] != nil || session[:ratings] != nil)
      redirect_to movies_path(sort: session[:sort], ratings: session[:ratings])
    end

    session[:sort] = params[:sort] || session[:sort]
    session[:ratings] = params[:ratings] || session[:ratings]

    params[:sort] ||= session[:sort]
    params[:ratings] ||= session[:ratings]

    @ratings_to_show = params[:ratings] ? params[:ratings].keys : (session[:ratings] || Movie.all_ratings)
    @movies = Movie.with_ratings(@ratings_to_show).order(params[:sort])
    @highlight_column = params[:sort]

    # # Redirect to the updated URL with session data
    # redirect_to movies_path(sort: params[:sort], ratings: params[:ratings]) unless params[:sort].blank? && params[:ratings].blank?
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
