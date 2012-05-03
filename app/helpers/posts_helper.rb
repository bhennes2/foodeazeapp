module PostsHelper
  
  def create_post(params)
    subject = params[:subject]
    
    if subject == 'food'
      food_special = Food.create(:content => params[:content])
      post = Post.create(:restaurant_id => params[:restaurant_id], :food_id => food_special.id )
      food_special.post_id = post.id
      food_special.save
    elsif subject == 'drink'
      drink_special = Drink.create(:content => params[:content])
      post = Post.create(:restaurant_id => params[:restaurant_id], :drink_id => drink_special.id )
      drink_special.post_id = post.id
      drink_special.save
    end
  end
  
  def get_post_content(post)
    if post.type == 'food'
      food_special = post.foods
      post_hash = { :data => food_special[0], :type => 'food' }
    elsif post.type == 'drink'
      drink_special = post.drinks
      post_hash = { :data => drink_special[0], :type => 'drink' }
    end 
  end
  
  def update_post(post, params)
    subject = params[:subject]
    
    if subject == post.type
      if subject == 'food'
        food_special = post.foods[0]
        food_special.update_attributes(:content => params[:content])
      elsif subject == 'drink'
        drink_special = post.drinks[0]
        drink_special.update_attributes(:content => params[:content])
      end
    else
      post.destroy
      
      create_post(params)
      # delete old post & start another
    end
  end
  
end