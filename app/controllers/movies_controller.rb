BG_WARNING = "\bhilite\b/ +p-3 mb-2 bg-warning text-dark"

class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @ratings_to_show = params.has_key?(:ratings) ? params[:ratings].keys : @all_ratings
    @rating_hash = Hash[@ratings_to_show.map { |key| [key.to_sym, '1'] }]
    
    @sort_by = params.has_key?(:sort_by) ? (session[:sort_by] = params[:sort_by]) : session[:sort_by]
    case @sort_by
    when "title"
      @title_header = BG_WARNING
    when "release_date"
      @release_date_header = BG_WARNING
    end

    if params[:sort_by] != session[:sort_by] && params.has_key?(:sort_by)
      session[:sort_by] = @sort_by
      redirect_to movies_path({:ratings => params[:ratings], :sort_by => @sort_by})
    end

    if params[:ratings] != session[:ratings] && params.has_key?(:ratings)
      session[:sort_by] = @sort_by
      session[:ratings] = params[:ratings]
      redirect_to movies_path({:ratings => params[:ratings], :sort_by => @sort_by})
    end
    
    @movies = Movie.order(@sort_by).with_ratings(@ratings_to_show)
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
