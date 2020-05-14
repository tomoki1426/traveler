class PostsController < ApplicationController
  def new
    @post = current_user.posts.build
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    @post = current_user.posts.build(post_params)
     if @post.save
      flash[:success] = 'メッセージを投稿しました。'
      redirect_to root_url
     else
      @posts = current_user.posts.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'メッセージの投稿に失敗しました。'
      render 'toppages/index'
     end
  end

  def destoy
    @post.destroy
    flash[:success] = 'メッセージを削除しました。'
    redirect_back(fallback_location: root_path)
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
