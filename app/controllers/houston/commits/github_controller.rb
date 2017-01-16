module Houston
  module Commits
    class GithubController < ::ApplicationController
      skip_before_action :verify_authenticity_token

      # https://developer.github.com/webhooks/#events
      EVENT_HANDLERS = {
        "pull_request" => Github::PullRequestEvent,
        "push" => Github::PostReceiveEvent,
        "commit_comment" => Github::CommitCommentEvent,
        "issue_comment" => Github::IssueCommentEvent,
        "pull_request_review_comment" => Github::DiffCommentEvent,
        "pull_request_review" => Github::PullRequestReviewEvent
      }.freeze

      def hooks
        event = request.headers["X-GitHub-Event"]

        if event == "ping"
          Rails.logger.info "\e[32m[github] ping received\e[0m"
          head 200

        elsif event_processor = EVENT_HANDLERS[event]
          payload = params.fetch "hook"
          event_processor.process! payload.to_h
          head 200

        else
          Rails.logger.warn "\e[33m[github] Unrecognized event: #{event}\e[0m"
          head 404
        end
      end

    end
  end
end
