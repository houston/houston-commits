Action.ignored_exceptions.concat [
  Rugged::NetworkError,
  Rugged::OSError,
  Octokit::BadGateway,
  Octokit::ServerError,
  Octokit::InternalServerError
]
