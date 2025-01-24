class ProfilesController < ApplicationController
  before_action :set_user, only: %i[edit update]

  def edit
    @user = current_user
  end

  def update
    if current_user.update(user_params)
      redirect_to profile_path, notice: "プロフィールを更新しました"
    else
      render :edit
    end
  end

  def show
    @user = current_user
    @boards = @user.boards.order(created_at: :desc).page(params[:page]).per(30)
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:email, :user_name, :avatar, :avatar_cache, :bio)  # avatar_urlは削除
  end
end
