class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    # render json: request.env['omniauth.auth']
    oauth_authentication
  end

  def vkontakte
    oauth_authentication
  end

  # def twitter
  #   oauth_authentication
  # end

  private

  def oauth_authentication
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message_for_action
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def set_flash_message_for_action
    set_flash_message(:notice, :success, kind: action_name) if is_navigational_format?
  end
end
