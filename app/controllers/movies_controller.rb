class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    
    # get selected ratings (if any)
    if (params[:ratings] != nil)
      @selected_ratings = params[:ratings].keys
    elsif (params[:selected_ratings] != nil)
      @selected_ratings = params[:selected_ratings].split('$')
    else
      @selected_ratings = []
    end
    
    # get selected sort (if any)
    sortby = params[:sortby]
    
    # Clear any previous selections
    session.clear
    session[:selected_ratings] = []
    session[:sortby] = ''
    
    # Check if user selected any ratings
    if (@selected_ratings.length > 0)
      # Save selected ratings
      session[:selected_ratings] = @selected_ratings
      
      # Check if user wants to sort
      if (sortby != nil)
        @movies = Movie.where(:rating => @selected_ratings).order(sortby)
      else
        @movies = Movie.where(:rating => @selected_ratings)
      end
    else
      # Check if user wants to sort
      if (sortby != nil)
        @movies = Movie.order(sortby)
      else
        @movies = Movie.all
      end
    end
    
    # Check if column heading needs hilighting
    if (sortby != nil)
      # Save selected sort order
      session[:sortby] = sortby
      if (sortby == 'title')
        @title_class = 'hilite'
      elsif (sortby == 'release_date')
        @release_date_class = 'hilite'
      end
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
