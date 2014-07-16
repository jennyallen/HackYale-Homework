class SessionsController < ApplicationController
	def new
	end
	def create
	    @user = User.find_by(netid: params[:session][:netid].downcase)
	    if @user # && @user.authenticate(params[:session][:password])
	      flash[:success] = 'welcome to Pear'
	      sign_in @user
	      redirect_back_or @user
	    else
	      flash.now[:error] = 'invalid netid'
	      render 'new' #HERE
	    end
	end

	def destroy
		sign_out
		redirect_to root_url
	end
end
