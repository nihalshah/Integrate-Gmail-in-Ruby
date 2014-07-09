class UsersController < ApplicationController

	def new
		@user = User.new

	end

	def create

		@user1 = User.new(params[:user])
	  	if @user1.save
	  		flash[:status] =true
	  		flash[:alert] = "Congrats, you've registered!"
	  		session[:user_id] = @user1.id
	  		redirect_to show_path

	  	else
	  		
	  		flash[:status] =false
	    	flash[:alert] = @user1.errors.full_messages

			@user = User.new
	    	if !params[:user].nil?
				@user.firstname = params[:user][:firstname]
				@user.lastname = params[:user][:lastname]
				@user.username = params[:user][:username]
			end

		
	    	render "new"
	  	end

	end

	def index
		
	end
	def charts
		@chart = User.select(:lastname)
		@len = @chart.length
		i =0
		@chart1 = []
		@chart2 = []
		 while i< @len

			@chart1[i]=[@chart[i].lastname , User.where(:lastname => @chart[i].lastname).length]
			i+=1
		 end
		 i=0
 		 while i< 2

			@chart2[i]=[@chart[i].lastname , User.where(:lastname => @chart[i].lastname).length]
			i+=1
		 end
		
	end
	def login
	
		if session[:user_id].nil?
		render "login"
		else
		@user = User.find(session[:user_id])

			if !@user.nil?
				render "show"
			else
				render "login"
			end

		end
	end

	def validate
		
		if !params[:log].nil?
			@user = User.validate_login(params[:log][:username], params[:log][:password])

			if @user
				session[:user_id] = @user.id
				redirect_to show_path
			else
				flash[:status] = false
				flash[:alert] = "Incorrect Username and Password"
				redirect_to login_path
			end
		else
			redirect_to login_path
		end
	end

	def show

		if session[:user_id].nil?
			flash[:status] = false
			flash[:alert] = " You need to login in First"
			redirect_to login_path
		else
			@user = User.find(session[:user_id])

			if !@user.nil?
				render "show"
			else
				redirect_to login_path
			end
		end
		
	end

	def edit
		@user = User.find(session[:user_id])

		if @user.nil?
			redirect_to login_path
		end

	end

	def update
		
		@user = User.find(session[:user_id])

		if !params[:user].nil?
		
			@user.firstname = params[:user][:firstname]
			@user.lastname = params[:user][:lastname]
			@user.username = params[:user][:username]
			@user.password = params[:user][:password]
			@user.password_confirmation = params[:user][:password_confirmation]

			if @user.save
				flash[:status] = true
				flash[:alert] = "Information Updated"
				redirect_to show_path
			else
				flash[:status] = false
				flash[:alert] = @user.errors.full_messages
				redirect_to edit_path
			end
			
		end

		

	end

def logout
	session[:user_id] = nil
	redirect_to '/'
	
end
##################################################################################
# 			Everthing From here is code for Gmail Integration In ruby
##################################################################################

def gmail
end

def authgmail
if session[:gmail_us].nil?
		
	if !params[:username].nil? && !params[:password].nil?

			@gusername = params[:username]
			@gpassword = params[:password]
			
			session[:gmail_us] = @gusername
			session[:gmail_pa] = @gpassword

			@gmail = Gmail.new(@gusername,@gpassword)

			render "display", :layout=>false
			@gmail.logout
		end
	else
			render "display", :layout=>false
	end
	
end

def display
if session[:gmail_us].nil?
	redirect_to gmail_path
end
end

def updategmail

	@gmail = Gmail.new(session[:gmail_us],session[:gmail_pa])
	@msg = @gmail.inbox.count(:unread) 
	render :text => @msg
	@gmail.logout
end


def logoutgmail
	
	session[:gmail_us] = nil
	session[:gmail_pa] = nil
	render "userform", :layout =>false
	
end

def userform
	
end

def checksession
	if session[:gmail_us].nil?
		render "userform", :layout =>false
	else
		render "display", :layout =>false
	end
end

end
