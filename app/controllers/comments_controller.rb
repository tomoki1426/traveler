class CommentsController < ApplicationController
  def create
  @post = Post.find(params[:post_id])
  @comments = @post.comments.includes(:user).all
  @comment = @post.comments.build(content_params)
  @comment.user_id = current_user.id
  if @comment.save
    flash[:success] = "コメントしました"
    redirect_to post_url(@post)
  else
    flash.now[:danger] = "コメントできません"
    render template: "posts/show"
  end 
  end
  
  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    redirect_back(fallback_location: root_path)
  end 
  
  
  private
  def content_params
    params.require(:comment).permit(:content)
  end 
end
