class SessionsController < ApplicationController
	def new
	end

	def create
		user = User.find_by_email(params[:email].downcase)

		if user && user.authenticate(params[:password])
			session[:user_id] = user.id
			sign_in user
			redirect_to user
		else
			# Flash.now is used since this is a rendered page. It will
			# persist on other pages if just flash was used.
			flash.now[:error] = 'Invalid email/password combination'
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_url
	end
end
