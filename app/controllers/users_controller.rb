class UsersController < ApplicationController
   before_action :require_user_logged_in, only: [:index, :show, :edit, :update, :destroy]
  def index
     @users = User.order(id: :desc).page(params[:page]).per(25)
  end

  def show
     @user = User.find(params[:id])
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
  end
  
#ユーザーに変えるかな  
  
 private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :content, :image_name)
    end

end
