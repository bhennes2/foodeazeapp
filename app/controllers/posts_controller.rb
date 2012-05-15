class PostsController < ApplicationController
  
  before_filter :signed_in
  before_filter :correct_restaurant, :only => [:edit]
  
  # def prepare_access_token(oauth_token, oauth_token_secret)
  #     consumer = OAuth::Consumer.new('rbttS17LFyD5l6joW1AkXQ', 'MlqpHlcUcDyhnUILBM9XcNZNeVMo5Oa2djZk9ImY', {:site => "http://api.twitter.com"})
  #         # now create the access token object from passed values
  #         token_hash = { :oauth_token => oauth_token, :oauth_token_secret => oauth_token_secret }
  #         access_token = OAuth::AccessToken.from_hash(consumer, token_hash)
  #     return access_token
  # end
  # 
  # def tweet(status)
  #     # Exchange our oauth_token and oauth_token secret for the AccessToken instance.
  #     @access_token = prepare_access_token(session[:token], session[:secret])
  # 
  #     @response = @access_token.request(:post, "http://api.twitter.com/1/statuses/update.json", :status => "Hello world")
  #     
  #     puts @response
  # end
  
  def index
    @title = 'My posts'
    @post_count = current_restaurant.posts.count
    
    @food_specials = current_restaurant.foods.order('created_at DESC')
    @drink_specials = current_restaurant.drinks.order('created_at DESC')
    
    respond_to do |format|
      format.html
      format.json { render :json => @posts }
    end
    
  end
  
  def new
    @title = 'Create'
    @post = Post.new
    @user_agent =  request.env['HTTP_USER_AGENT'].downcase
  end
  
  def create
    create_post(params)
    
    if params[:tweet] == "1"
      #send tweet
      status = params[:content]

      #tweet(status)
      Twitter.configure do |config|
        config.consumer_key = 'rbttS17LFyD5l6joW1AkXQ'
        config.consumer_secret = 'MlqpHlcUcDyhnUILBM9XcNZNeVMo5Oa2djZk9ImY'
        config.oauth_token = session[:token]
        config.oauth_token_secret = session[:secret]
      end
      
      Twitter.update(status)
      
    end

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