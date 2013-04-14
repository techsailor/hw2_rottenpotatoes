class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    session[:params] ||= {}
    old = session[:params]

    redirect_to movies_path({:sortby => old[:sortby], :ratings => old[:ratings]}) if (params[:sortby].blank? && old[:sortby].present?) || (params[:ratings].blank? && old[:ratings].present?)
    params[:sortby] = old[:sortby] if params[:sortby].nil?
    params[:ratings] = old[:ratings] if params[:ratings].nil?
    session[:params] = {:sortby => params[:sortby], :ratings => params[:ratings]}
    params = session[:params]


#@movies = Movie.all
  @sby = params[:sortby]

  @all_ratings = Movie::VALID_RATINGS
  @ratings = params[:ratings]
  if ["title","release_date"].include? @sby
    if !@ratings.nil?
      @movies = Movie.find(:all, :conditions => {:rating => @ratings.keys}, :order => [@sby, 'ASC'].join(" "))
    else
      @movies = Movie.order("#{@sby} ASC ")
    end
  else
    if !@ratings.nil?
      @movies = Movie.find(:all, :conditions => {:rating => @ratings.keys})
    else
      @movies = Movie.all
    end
  end

#if @sby == "title"
#    @movies = Movie.order("#{params[:sortby]} ASC")
#  elsif @sby == 'release_date'
#    @movies = Movie.order("#{params[:sortby]} ASC")
#  else
#    @movies = Movie.all
#  end

#  @movies = Movie.order('title ASC')
#  @movies = Movie.order('release_date ASC')
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
