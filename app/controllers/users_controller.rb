class UsersController < ApplicationController
   before_action :require_user_logged_in, only: [:index, :show, :edit, :update, :destroy, :followings, :followers, :likes, :search]
   before_action :current_user, only: [:edit]
  def index
     @users = User.order(id: :desc).page(params[:page]).per(25)
  end

  def show
     @user = User.find(params[:id])
    @posts = @user.posts.order(id: :desc).page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
      @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end

  def edit
     @user = User.find(params[:id])
     unless  @user == current_user
     redirect_to root_url
     end
  end

  def update
     @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:success] = 'プロフィールは正常に更新されました'
      redirect_to @user
    else
      flash.now[:danger] = 'プロフィールは更新されませんでした'
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user == current_user
    @user.destroy
    flash[:success] = 'アカウントを削除しました。'
    redirect_to root_url
    else
      render :edit
    end 
  end
  
  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end
  
  def likes
    @user = User.find(params[:id])
    @likes = @user.likes.page(params[:page])
    counts(@user)
  end
  
   def search
    @user = User.search(params[:keyword]).page(params[:page]).per(25)
   end
 private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :content, :image_name)
    end
    
    

end
