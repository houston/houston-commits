module Houston::Commits
  class ApplicationController < ::ApplicationController
    helper Houston::Commits::CommitHelper
    helper Houston::Commits::AnsiHelper
  end
end
