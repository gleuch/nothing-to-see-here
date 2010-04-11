ActionController::Routing::Routes.draw do |map|


  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'

  map.resources :users
  map.resource  :session

  # /account
  map.resource  :account

  # /portfolios
  map.resources :portfolios do |portfolio|
    # /portfolios/:portfolio_id/timesheets
    portfolio.resources :timesheets

    # /portfolios/:portfolio_id/todos
    portfolio.resources :todos

    # /portfolios/:portfolio_id/clients
    portfolio.resources :clients do |client|
      # /portfolios/:portfolio_id/clients/:client_id/timesheets
      client.resources :timesheets

      # /portfolios/:portfolio_id/clients/:client_id/todos
      client.resources :todos

      # /portfolios/:portfolio_id/clients/:client_id/projects
      client.resources :projects do |project|
        # /portfolios/:portfolio_id/clients/:client_id/projects/:project_id/timesheets
        project.resources :timesheets do |timesheet|
          timesheet.resources :comments
        end

        # /portfolios/:portfolio_id/clients/:client_id/projects/:project_id/messages
        project.resources :messages do |message|
          message.resources :comments
        end

        # /portfolios/:portfolio_id/clients/:client_id/projects/:project_id/todos
        project.resources :todos do |todo|
          todo.resources :comments
        end

      end
    end
  end

  # /clients
  map.resources :clients

  # /projects
  map.resources :projects

  # default routes?
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'


  # / (dashboard)
  map.root :controller => 'dashboards', :action => 'index'


end
