class ApplicationController < ActionController::Base
  before_action :require_login
  add_flash_types :success, :danger
  include MetaTags::ControllerHelper

  private

  def not_authenticated
    redirect_to login_path, flash: { danger: "ログインしてください" }
  end
end