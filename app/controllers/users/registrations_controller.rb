# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    build_resource(sign_up_params)


    if resource.family_id.blank?
      family_name = params.dig(:user, :new_family).to_s.strip
      if family_name.blank?
        # Add an error and re-render
        resource.errors.add(:base, "Family name can't be blank")
        clean_up_passwords(resource)
        set_minimum_password_length
        respond_with resource
        return
      end

      # Create family
      Family.transaction do
        family = Family.new(name: family_name)
        unless family.save
          resource.errors.add(:base, family.errors.full_messages.to_sentence)
          raise ActiveRecord::Rollback
        end
      resource.family = family
      resource.role = "parent"
      end
    else
      # If using f.association :family, sign_up_params likely includes :family_id
      # Ensure resource.family_id is set from params (build_resource already did this if permitted)
      # Optionally validate presence of family if required
    end

    if resource.save
      # normal Devise success flow...
      sign_up(resource_name, resource)
      respond_with resource, location: after_sign_up_path_for(resource)
    else
      clean_up_passwords(resource)
      set_minimum_password_length
      respond_with resource
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  private

  def sign_up_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      :family_id
    )
  end
end
