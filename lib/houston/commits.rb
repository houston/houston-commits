require "houston/commits/engine"
require "houston/commits/configuration"

module Houston
  module Commits
    extend self

    def config(&block)
      @configuration ||= Commits::Configuration.new
      @configuration.instance_eval(&block) if block_given?
      @configuration
    end

  end


  # Extension Points
  # ===========================================================================
  #
  # Read more about extending Houston at:
  # https://github.com/houston/houston-core/wiki/Modules


  # Register events that will be raised by this module
  #
  #    register_events {{
  #      "commits:create" => params("commits").desc("Commits was created"),
  #      "commits:update" => params("commits").desc("Commits was updated")
  #    }}


  # Add a link to Houston's global navigation
  #
  #    add_navigation_renderer :commits do
  #      name "Commits"
  #      icon "fa-thumbs-up"
  #      path { Houston::Commits::Engine.routes.url_helpers.commits_path }
  #      ability { |ability| ability.can? :read, Project }
  #    end


  # Add a link to feature that can be turned on for projects
  #
  #    add_project_feature :commits do
  #      name "Commits"
  #      icon "fa-thumbs-up"
  #      path { |project| Houston::Commits::Engine.routes.url_helpers.project_commits_path(project) }
  #      ability { |ability, project| ability.can? :read, project }
  #    end

end
