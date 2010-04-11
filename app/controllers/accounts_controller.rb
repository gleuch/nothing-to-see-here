class AccountsController < ApplicationController

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(params[:account])
    @account.owner = current_user if logged_in?

    if @account.save
      @account.users << @account.owner

      flash[:notice] = "Your account was successfully saved."
      redirect_to("/") and return
    else
      flash[:notice] = "Your account could not be saved."
      render :action => 'new'
    end
  end

  def destroy

  end


protected


end
