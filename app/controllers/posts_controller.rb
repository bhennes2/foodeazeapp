class PostsController < ApplicationController
  
  before_filter :signed_in
  before_filter :correct_restaurant, :only => [:edit]
  
  def index
    @title = 'My posts'
    @post_count = current_restaurant.posts.count
    
    @food_specials = current_restaurant.foods
    @drink_specials = current_restaurant.drinks
    
    respond_to do |format|
      format.html
      format.json { render :json => @posts }
    end
    
  end
  
  def new
    @title = 'Create'
    @post = Post.new
  end
  
  def create
    create_post(params)

    redirect_to :action => 'index'
  end
  
  def show
    @post = Post.find_by_id(params[:id])
    @post_content = get_post_content(@post)
  end
  
  def edit
    @title = 'Editing a post'
    @post = Post.find_by_id(params[:id])
    @post_content = get_post_content(@post)
  end
  
  def update
    post = Post.find_by_id(params[:id])
    update_post(post, params)
    
    redirect_to :action => 'index'
  end
  
  def destroy
    @post = Post.find_by_id(params[:id])
    @post.destroy
    
    redirect_to :action => 'index'
  end
  
end