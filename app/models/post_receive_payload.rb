class PostReceivePayload
  attr_reader :agent_email, :sha, :branch

  def initialize(params)
    parse_params(params)
  end

  def parsed?
    sha.present?
  end

  def parse_params(params)
    (params = MultiJson.load(params["payload"])) if params.key?("payload")
    parse_github_style_params(params) if params
  end

  def parse_github_style_params(params)
    @sha = params["after"]
    @agent_email = parse_github_style_agent(params["pusher"])
    @branch = params["ref"].split("/").last if params.key?("ref")
  end

  def parse_github_style_agent(pusher)
    return nil unless pusher && pusher.key?("email")
    return pusher["email"] unless pusher.key?("name")
    "#{pusher["name"].inspect} <#{pusher["email"]}>"
  end

end
