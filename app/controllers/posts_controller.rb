class PostsController < ApplicationController
     before_action :require_user_logged_in
     before_action :correct_user, only: [:destroy]
  
  def new
    @post = current_user.posts.build
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.includes(:user).all
    @comment  = @post.comments.build(user_id: current_user.id) if current_user
  end

  def create
    @post = current_user.posts.build(post_params)
     if @post.save
      flash[:success] = 'メッセージを投稿しました。'
      redirect_to root_url
     else
      @posts = current_user.feed_posts.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'メッセージの投稿に失敗しました。'
      render 'toppages/index'
     end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:success] = 'メッセージを削除しました。'
    redirect_to root_url
  end
  
   private

  def post_params
    params.require(:post).permit(:content, :title, :image_name)
  end
  
   def correct_user
    @post = current_user.posts.find_by(id: params[:id])
    unless @post
      redirect_to root_url
    end
   end
end
