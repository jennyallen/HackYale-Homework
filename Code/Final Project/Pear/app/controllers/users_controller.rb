class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.all
  end

  def show
  	@user = User.find(params[:id])
  end
  def new # for signing up users, but outside of scope
  	# @user = User.new
  end
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'user deleted'
    redirect_to users_url
  end

  # def update
  #   if @user.update_attributes(user_params)
  #     flash[:success] = "Profile updated"
  #     redirect_to @user
  #   else
  #     render 'edit'
  #   end
  # end

  # def edit #goes to views/users/edit.html.erb
  # end

  # def create # for sign up
  #   @user = User.new(params[:user])    # Not the final implementation!
  #   if @user.save
  #     # Handle a successful save.
  #   else
  #     render 'new'
  #   end
  # end

  private
    def user_params
      params.require(:user).permit(:netid)
    end
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "please enter netid"
      end
    end
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
