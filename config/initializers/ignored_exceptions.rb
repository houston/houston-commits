Action.ignored_exceptions.concat [
  Rugged::NetworkError,
  Octokit::BadGateway,
  Octokit::ServerError,
  Octokit::InternalServerError
]
