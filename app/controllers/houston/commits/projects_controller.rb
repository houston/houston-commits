module Houston
  module Commits
    class ProjectsController < Houston::Commits::ApplicationController

      def new_from_github
        @team = Team.find params[:team_id]
        authorize! :create, @team.projects.build

        existing_projects = Project.unscoped.where("props->>'git.location' LIKE '%github.com%'")
        github_repos = Houston.benchmark "Fetching repos" do
          Houston.github.repos
        end
        @repos = github_repos.map do |repo|
          project = existing_projects.detect { |project|
            [repo.git_url, repo.ssh_url, repo.clone_url].member?(project.props["git.location"]) }
          { name: repo.name,
            owner: repo.owner.login,
            full_name: repo.full_name,
            private: repo[:private],
            git_location: repo.ssh_url,
            project: project }
        end
      end


      def create_from_github
        @team = Team.find params[:team_id]
        authorize! :create, @team.projects.build

        repos = params.fetch(:repos, [])
        projects = Project.transaction do
          repos.map do |repo|
            owner, name = repo.split("/")
            title = name.humanize.gsub(/\b(?<!['’.`])[a-z]/) { $&.capitalize }.gsub("-", "::")
            @team.projects.create!(
              name: title,
              slug: name,
              props: {
                "adapter.versionControl" => "Git",
                "git.location" => "git@github.com:#{repo}.git"})
          end
        end

        flash[:notice] = "#{projects.count} projects added"
        redirect_to teams_path

      rescue ActiveRecord::RecordInvalid
        flash[:error] = $!.message
        redirect_to :back
      end

    end
  end
end
