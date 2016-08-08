class MapsController < ApplicationController
  before_action except: :show do
  if @current_user.nil?
    redirect_to sign_in_path, alert: "Please Sign In"
  end

end
  def index
    @user = @current_user

  end



end
