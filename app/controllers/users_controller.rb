class UsersController < ApplicationController
  

  def new
    @user = User.new
    @account = Account.new(params[:account])
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    @account = Account.new(params[:account].merge({ :email => params[:user][:email] }))

    success = @user && @user.save
    if success && @user.errors.empty?
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs. ----
      # reset session

      @account.owner_id = @user.id # Set as owner
      
      if @account.save
        @account.users << @user # Add them to the account.
        self.current_user = @user # Make user logged-in

        flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
        redirect_to new_portfolio_path
      else
        @user.destroy # User should not exist w/o an account... lame, I know!

        flash[:error] = "There was a problem creating your account. Please try again."
        render :action => 'new'
      end
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again."
      render :action => 'new'
    end
  end


protected


end
