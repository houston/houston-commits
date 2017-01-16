module Houston
  module Commits
    module UserExt
      extend ActiveSupport::Concern


      included do
        has_and_belongs_to_many :commits
      end


      # Extract to Houston::GitHub
      # ------------------------------------------------------------------------- #

      def self.find_by_github_username(username)
        find_by_prop "github.username", username do |username|

          # Look up the email address of the GitHub user and see if we can
          # identify the Houston user by the GitHub user's email address.
          user = Houston.github.user(username)
          user = find_by_email_address user.email if user

          # We couldn't find the user by their email address, now
          # we'll look at their nicknames
          user = find_by_nickname username unless user

        end
      end

      def github_username
        props["github.username"]
      end

      # ------------------------------------------------------------------------- #


    end
  end
end
