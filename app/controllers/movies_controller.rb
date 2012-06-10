class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    if params.has_key? :ratings
      where = "rating in ('#{params[:ratings].keys.join("','")}')"
      session[:ratings] = params[:ratings]
    else
      if session.has_key? :ratings
        params[:ratings] = session[:ratings]
        flash.keep
        redirect_to movies_path(params) and return
      else
        params[:ratings] = {}
      end
    end
    if params.has_key? :sort 
      order = "#{params[:sort]}"
      session[:sort] = params[:sort]
    else
      if session.has_key? :sort
        params[:sort] = session[:sort]
        flash.keep
        redirect_to movies_path(params) and return
      end
    end
    @movies = Movie.where(where).order(order).all
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
