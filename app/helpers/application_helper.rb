# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper


  def smart_breadcrumbs(*opts)
    options, str = {:separator => ' &gt; '}.merge(opts.extract_options!), []

    p options

    str << options[:prefix] unless options[:prefix].blank?
    str << link_to(@portfolio.title, portfolio_path(@portfolio.slug)) unless @portfolio.blank?
    str << link_to(@client.name, portfolio_client_path(@portfolio.slug, @client.slug)) unless @portfolio.blank? || @client.blank?
    str << link_to(@project.name, portfolio_client_project_path(@portfolio.slug, @client.slug, @project.slug)) unless @portfolio.blank? || @client.blank? || @project.blank?
    str << options[:suffix] unless options[:suffix].blank?

    str.join(options[:separator])
  end

  def which_section?
    # Section nesting
    str = 'portfolio' unless @portfolio.blank?
    str = 'client'    unless @portfolio.blank? || @client.blank?
    str = 'project'   unless @portfolio.blank? || @client.blank? || @project.blank?

    str
  end



  def get_timesheet_path
    link = portfolio_timesheets_path(@portfolio.slug) unless @portfolio.blank?
    link = portfolio_client_timesheets_path(@portfolio.slug, @client.slug) unless @portfolio.blank? || @client.blank?
    link = portfolio_client_project_timesheets_path(@portfolio.slug, @client.slug, @project.slug) unless @portfolio.blank? || @client.blank? || @project.blank?
    return link || nil
  end

  def get_new_timesheet_path
    link = new_portfolio_timesheet_path(@portfolio.slug) unless @portfolio.blank?
    link = new_portfolio_client_timesheet_path(@portfolio.slug, @client.slug) unless @portfolio.blank? || @client.blank?
    link = new_portfolio_client_project_timesheet_path(@portfolio.slug, @client.slug, @project.slug) unless @portfolio.blank? || @client.blank? || @project.blank?
    return link || nil
  end


end
