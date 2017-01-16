require "houston/commits/engine"
require "houston/commits/configuration"
require "houston/adapters/version_control"
require "octokit"
require "rugged"

module Houston
  module Commits
    extend self

    def config(&block)
      @configuration ||= Commits::Configuration.new
      @configuration.instance_eval(&block) if block_given?
      @configuration
    end

  end


    # When the git:post_receive hook is triggered, a commit range of
    # 0000000000000000000000000000000000000000...10fb27e indicates the creation of a branch, while
    # 10fb27e...0000000000000000000000000000000000000000 indicates the deletion of a branch
    NULL_GIT_COMMIT = "0000000000000000000000000000000000000000".freeze





  # Extension Points
  # ===========================================================================
  #
  # Read more about extending Houston at:
  # https://github.com/houston/houston-core/wiki/Modules


  # Register events that will be raised by this module

   register_events {{
     "commit:create"                   => params("commit").desc("A new commit was created"),

     "deploy:completed"                => params("deploy").desc("A deploy just finished"),
     "deploy:succeeded"                => params("deploy").desc("A deploy succeeded"),
     "deploy:failed"                   => params("deploy").desc("A deploy failed"),

     "github:comment:create"           => params("comment").desc("A comment was added to a commit, diff, or issue on GitHub"),
     "github:comment:{type}:create"    => params("comment").desc("A comment was added to a {type} on GitHub"),
     "github:comment:update"           => params("comment").desc("A comment on a commit, diff, or issue was updated on GitHub"),
     "github:comment:{type}:update"    => params("comment").desc("A comment on a {type} was updated on GitHub"),
     "github:comment:delete"           => params("comment").desc("A comment on a commit, diff, or issue was deleted on GitHub"),
     "github:comment:{type}:delete"    => params("comment").desc("A comment on a {type} was deleted on GitHub"),

     "github:pull:opened"              => params("pull_request").desc("A pull request was opened"),
     "github:pull:updated"             => params("pull_request", "changes").desc("A pull request was updated"),
     "github:pull:closed"              => params("pull_request").desc("A pull request was closed"),
     "github:pull:reopened"            => params("pull_request").desc("A pull request was reopened"),
     "github:pull:synchronize"         => params("pull_request").desc("Commits were pushed to a pull request"),
     "github:pull:reviewed"            => params("pull_request", "review").desc("A pull request was reviewed"),
     "github:pull:reviewed:{state}"    => params("pull_request", "review").desc("A pull request was reviewed and {state}")
   }}


  # Add a link to Houston's global navigation
  #
  #    add_navigation_renderer :commits do
  #      name "Commits"
  #      path { Houston::Commits::Engine.routes.url_helpers.commits_path }
  #      ability { |ability| ability.can? :read, Project }
  #    end


  # Add a link to feature that can be turned on for projects
  #
  #    add_project_feature :commits do
  #      name "Commits"
  #      path { |project| Houston::Commits::Engine.routes.url_helpers.project_commits_path(project) }
  #      ability { |ability, project| ability.can? :read, project }
  #    end


module_function

  def github
    @github ||= Octokit::Client.new(access_token: Houston::Commits.config.github[:access_token], auto_paginate: true)
  end

end
