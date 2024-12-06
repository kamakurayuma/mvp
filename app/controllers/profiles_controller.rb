class ProfilesController < ApplicationController
    before_action :set_user, only: %i[edit update]

    def edit; end
  
    def update
      if @user.update(user_params)
        redirect_to profile_path, success: 'プロフィールを更新しました'
      else
        flash.now['danger'] = 'プロフィールを更新できませんでした'
        render :edit, status: :unprocessable_entity
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
      params.require(:user).permit(:email, :user_name, :avatar, :avatar_cache, :bio)
    end
  end