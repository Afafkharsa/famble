class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  include Pundit::Authorization

  helper_method :fab_chat

  def fab_chat
    return nil unless user_signed_in? && current_user.role.present?

    @fab_chat ||= current_user.chats.order(created_at: :desc).first ||
                  current_user.chats.create!(title: "Famble AI")
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :photo])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :family_id])
  end

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end
end
