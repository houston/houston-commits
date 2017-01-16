Houston::Commits::Engine.routes.draw do

  post "hooks/github", to: "github#hooks"



  # Commits API

  get "commits", to: "commits#index"

  scope "self" do
    get "commits", to: "commits#self"
  end



  # Deploys

  scope "projects/:project_id" do
    get "deploys/:id", to: "deploys#show", :as => :deploy

    post "deploy", to: "deploys#create"
    post "deploy/:environment", to: "deploys#create"
  end



  scope "teams/:team_id" do
    get "projects/new/github", to: "projects#new_from_github", as: :add_github_projects
    post "projects/new/github", to: "projects#create_from_github"
  end

end
