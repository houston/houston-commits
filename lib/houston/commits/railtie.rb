require "houston/commits/project_ext"
require "houston/commits/user_ext"

module Houston
  module Commits
    class Railtie < ::Rails::Railtie

      # The block you pass to this method will run for every request
      # in development mode, but only once in production.
      config.to_prepare do
        ::Project.send(:include, Houston::Commits::ProjectExt)
        ::User.send(:include, Houston::Commits::UserExt)
      end

    end
  end
end
