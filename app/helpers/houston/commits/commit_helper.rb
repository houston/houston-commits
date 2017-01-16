module Houston
  module Commits
    module CommitHelper

      def github_url?(project)
        project.repo.respond_to?(:project_url)
      end

      def github_project_url(project)
        project.repo.project_url if project.repo.respond_to?(:project_url)
      end

      def github_commit_url(project, sha)
        project.repo.commit_url(sha) if project.repo.respond_to?(:commit_url)
      end

      def github_commit_range_url(project, sha0, sha1)
        project.repo.commit_range_url(sha0, sha1) if project.repo.respond_to?(:commit_range_url)
      end


      def link_to_commit(commit, options={})
        return nil if commit.nil?

        project = commit.project
        content = block_given? ? yield : "<span class=\"commit-sha\">#{commit.sha[0...7]}</span>".html_safe

        return content unless url = github_commit_url(project, commit.sha)
        link_to content, url, options.reverse_merge(target: "_blank")
      end

      def link_to_commit_range_for_deploy(deploy)
        link_to_commit_range deploy.project, deploy.previous_deploy.try(:sha), deploy.sha
      end

      def link_to_commit_range(project, commit0, commit1)
        range = "#{format_sha(commit0)}<span class=\"ellipsis\">...</span>#{format_sha(commit1)}".html_safe
        return range unless github_url?(project)
        return range if commit0.blank? or commit1.blank?

        link_to range, github_commit_range_url(project, commit0, commit1), target: "_blank", title: "Compare"
      end

      def format_sha(sha)
        return "_"*8 if sha.blank?
        sha[0...7]
      end

    end
  end
end
