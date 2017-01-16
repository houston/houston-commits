module Houston
  module Commits
    module TestHelpers

      def bare_repo_path
        @bare_repo_path ||= File.expand_path("../../../../test/data/bare_repo.git", __FILE__)
      end

    end
  end
end
