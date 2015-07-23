class BlogPostsController < ApplicationController
  #include ApplicationHelper

  #before_action :user_is_admin?, except: [:index, :show]
  
  def index
    @posts = BlogPost.all
  end

  def show
    @post = BlogPost.find_by_id(params[:id])

    # check if we found this post, if not redirect
    if @post.nil?
      redirect_to root_path
    end
  end

  #def edit
  #  @post = BlogPost.find_by_id(params[:id])
  #
  #  # check we found the [pst
  #  if @post.nil?
  #    redirect_to blog_root
  #  end
  #end

end
