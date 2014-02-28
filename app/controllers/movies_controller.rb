class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    redirect = false

    # If user has pressed a way to sort, use the input
    if params[:sort_by]
      @sort_by = params[:sort_by]
      # Save this input into session
      session[:sort_by] = params[:sort_by]

    # If the user has not placed anything, use the settings in the session
    elsif session[:sort_by]
      @sort_by = session[:sort_by]
      redirect = true
    else
      @sort_by = nil
    end

    if params[:ratings]
      @ratings = params[:ratings]
      session[:ratings] = params[:ratings]
    elsif session[:ratings]
      @ratings = session[:ratings]
      redirect = true
    else
      @ratings = nil
    end
    
    # If there's a redirect, save the flash message and go to the correct page
    if redirect
      flash.keep
      redirect_to movies_path sort_by:@sort_by, ratings:@ratings
    end

    if @ratings and @sort_by
      @movies = Movie.where(rating:@ratings.keys).find(:all, :order=>(params[:sort_by]))
    elsif @ratings
      @movies = Movie.where(rating:@ratings.keys)
    elsif @sort_by
      @ratings = Hash.new
      @movies = Movie.find(:all, order: params[:sort_by])
    else
      @movies = Movie.all
    end
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
