class DashboardsController < ApplicationController


  def index
    if logged_in?
      render :action => 'index'
    else
      render :action => 'home'
    end
  end


protected


end
