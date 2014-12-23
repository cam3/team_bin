class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter  :verify_authenticity_token

  def all
    auth     = env["omniauth.auth"]
    user     = User.from_omniauth(auth, current_user)

    if user.persisted?
      flash.notice = "Signed in!"
      sign_in_and_redirect user
    else
      session["devise.user_attributes"] = auth
      flash.notice = %Q{You're almost done signing up! Fill in the information below and click "Sign up" to finish.}
      redirect_to new_user_registration_url
    end
  end

  alias_method :bnet, :all
  alias_method :steam, :all
end
