class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update ]
  skip_before_action :login_required, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to user_path(@user.id)
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
    if @user == current_user
      render "edit"
    else
      redirect_to users_path
    end
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice:"保存しました"
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :image, :image_cache)
  end

  def ensure_correct_user
    @user = User.find_by(id: params[:id])
    if @user.id != current_user.id
      # ここでいきなりcurrent_userを使えるのは、sessions_helperがapplication_controllerにincludeされているから
      flash[:notice] = "権限がありません"
      redirect_to pictures_path
    end
  end
end
