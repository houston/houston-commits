require "test_helper"

class CommitsApiTest < ActionDispatch::IntegrationTest
  fixtures :all

  setup do
    stub(Houston::Commits.config).identify_committers(anything).returns(["bob.lail@cph.org", "robert.lail@cph.org", "bob.lailfamily@gmail.com", "admin@example.com"])

    project = Project.create!(
      name: "Test",
      slug: "test",
      props: { "adapter.versionControl" => "Git", "git.location" => bare_repo_path })

    project.repo.all_commits.each do |sha|
      native_commit = project.repo.native_commit(sha)
      project.commits.from_native_commit(native_commit).save!
    end
  end


  test "should return a 401 if I'm not authenticated" do
    get "/self/commits"
    assert_response :unauthorized
  end


  test "should return a list of the user's commits" do
    get "/self/commits", env: env
    assert_response :success

    expected_commits = [
      "[fix] Resolved this ticket [#116] (1m)",
      "Added lib files for code coverage tests",
      "When you have eliminated the impossible, what remains,",
      "however improbable, must be true",
      "Create README.md",
      "new commit",
      "initial commit"
    ]

    response_json = MultiJson.load(response.body)
    commits = Array(response_json).map { |commit| commit["message"] }
    assert_equal expected_commits, commits
  end


  test "should return a list of the user's commits filtered by date range" do
    get "/self/commits",
      params: {start_at: Time.local(2013, 5, 23), end_at: Time.local(2013, 5, 24)},
      env: env
    assert_response :success

    expected_commits = [
      "When you have eliminated the impossible, what remains,",
      "however improbable, must be true"
    ]

    response_json = MultiJson.load(response.body)
    commits = Array(response_json).map { |commit| commit["message"] }
    assert_equal expected_commits, commits
  end


  def env
    { "HTTP_AUTHORIZATION" => "Basic " + Base64::encode64("admin@example.com:password") }
  end

end
