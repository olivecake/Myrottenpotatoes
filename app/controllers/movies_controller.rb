class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    redirect = false
    @all_ratings = Movie.all_ratings

    ratings = params[:ratings] || session[:ratings]
    if params[:ratings]
	session[:ratings] = params[:ratings]
    elsif session[:ratings]
	redirect = true
	params[:ratings] = session[:ratings]
	session.delete(:ratings)
    end

    order_by = params[:order_by] || session[:order_by]
    if params[:order_by]
	session[:order_by] = params[:order_by]
    elsif session[:order_by]
	redirect = true
	session.delete(:order_by)
	params[:order_by] = session[:order_by]
    end

    if redirect
	flash.keep
	redirect_to movies_path(:order_by=> order_by, :ratings=> ratings)
	return
    end

debugger 
    if !order_by.nil? and !session[:ratings].nil?
	@movies = Movie.find(:all, :order => "#{order_by} ASC", :conditions => {:rating => session[:ratings].keys})
    elsif !order_by.nil? and session[:ratings].nil?
	@movies = Movie.order("#{order_by} ASC")
    elsif !session[:ratings].nil? and order_by.nil?
	@movies = Movie.find(:all, :conditions => {:rating => session[:ratings].keys})
    else
	@movies = Movie.all
    end

    if session[:order_by] == "title"
	@title_class = "hilite"
    elsif session[:order_by] == "release_date"
	@release_date_class = "hilite"
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
