class PortfoliosController < ApplicationController

  before_filter :login_required
  before_filter :check_user_permissions, :only => [:new, :create, :edit, :update, :destroy]
  before_filter :check_account_limits, :only => [:new, :create]

  def index
    @portfolios = current_user.portfolios rescue nil
    
    # Skip this page if user is only part of one portfolio.
    redirect_to( portfolio_path(@portfolios.first.slug) ) and return if @portfolios.length == 1
  end

  def show
    @portfolio = current_user.portfolios.find_by_url_slug(params[:id]) rescue nil
    @portfolio ||= current_user.portfolios.find(params[:id]) rescue nil
  end

  def new
    @portfolio = Portfolio.new
  end

  def create
    @portfolio = Portfolio.new(params[:portfolio].merge({ :account_id => current_user.owned_account.id }))
    if @portfolio.save
      @portfolio.users << current_user

      flash[:notice] = 'Your portfolio was successfully created.'
      redirect_to portfolio_path(@portfolio.slug)
    else
      flash[:error] = 'There was a problem creating this portfolio. Please try again.'
      render :action => 'new'
    end
  end

protected

  def check_user_permissions
    raise NotAllowed, "You do not have permission to make this request." if current_user.owned_account.blank?
  end

  def check_account_limits
    max_portfolios = current_user.owned_account.option_portfolios_count
    if current_user.owned_account.portfolios.count >= max_portfolios
      raise MaxQuota, "You have reached the maximum number of #{pluralize max_portfolios, 'portfolio'} you can create for this account."
    end
  end

end
