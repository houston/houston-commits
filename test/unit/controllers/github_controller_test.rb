require "test_helper"

class GithubControllerTest < ActionController::TestCase
  tests Houston::Commits::GithubController

  setup do
    @routes = Houston::Commits::Engine.routes
    @request.headers['Content-Type'] = 'application/json'
  end


  context "When GitHub posts a ping event, it" do
    setup do
      request.headers["X-Github-Event"] = "ping"
    end

    should "respond with success" do
      post :hooks
      assert_response :success
    end
  end


  context "When GitHub posts a pull_request event, it" do
    setup do
      request.headers["X-Github-Event"] = "pull_request"
    end

    should "respond with success" do
      stub.instance_of(Github::PullRequestEvent).process!
      post :hooks, body: github_pull_request_event_payload
      assert_response :success
    end

    should "create or update a GitHub::PullRequest" do
      the_pull_request = hash_including(a_pull_request.pick("html_url"))
      mock(Github::PullRequest).upsert!(the_pull_request, as: "baxterthehacker")
      post :hooks, body: github_pull_request_event_payload
    end

    should "add a label to GitHub::PullRequest when the action is \"labeled\"" do
      pr = Github::PullRequest.new(id: 1, json_labels: [])
      stub(Github::PullRequest).upsert! { pr }
      stub(pr).persisted? { true }
      mock.instance_of(Github::PullRequestEvent).replace_labels!(1, [{"name" => "new-label", "color" => "#445566"}], as: "baxterthehacker")
      post :hooks, body: github_pull_request_event_payload(action: "labeled",
        label: {"name" => "new-label", "color" => "#445566"})
    end

    should "not add a label twice to GitHub::PullRequest when the action is \"labeled\"" do
      pr = Github::PullRequest.new(id: 1, json_labels: [{"name" => "new-label", "color" => "#333"}])
      stub(Github::PullRequest).upsert! { pr }
      stub(pr).persisted? { true }
      mock.instance_of(Github::PullRequestEvent).replace_labels!(1, [{"name" => "new-label", "color" => "#445566"}], as: "baxterthehacker")
      post :hooks, body: github_pull_request_event_payload(action: "labeled",
        label: {"name" => "new-label", "color" => "#445566"})
    end

    should "remove a label to GitHub::PullRequest when the action is \"unlabeled\"" do
      pr = Github::PullRequest.new(id: 1, json_labels: [{"name" => "removed-label", "color" => "#445566"}])
      stub(Github::PullRequest).upsert! { pr }
      stub(pr).persisted? { true }
      mock.instance_of(Github::PullRequestEvent).replace_labels!(1, [], as: "baxterthehacker")
      post :hooks, body: github_pull_request_event_payload(action: "unlabeled",
        label: {"name" => "removed-label", "color" => "#445566"})
    end
  end


  context "When GitHub posts a push event, it" do
    setup do
      request.headers["X-Github-Event"] = "push"
    end

    should "respond with success" do
      stub.instance_of(Github::PostReceiveEvent).process!
      post :hooks, body: github_push_event_payload
      assert_response :success
    end

    should "trigger a `hooks:project:post_receive` event for the project" do
      project = create(:project, slug: "public-repo")
      expected_payload = hash_including(MultiJson.load(github_push_event_payload).slice("before", "after"))
      mock(Houston.observer).fire("hooks:project:post_receive", project: project, params: expected_payload)
      post :hooks, body: github_push_event_payload
    end
  end


  context "When GitHub posts some other event, it" do
    setup do
      request.headers["X-Github-Event"] = "gollum"
    end

    should "respond with not_found" do
      post :hooks
      assert_response :not_found
    end
  end


private

  def github_push_event_payload
    @github_push_event_payload ||= File.read("#{path}/data/github_push_event_payload.json")
  end

  def github_pull_request_event_payload(options={})
    MultiJson.dump({
      action: "opened",
      sender: {login: "baxterthehacker"},
      pull_request: a_pull_request }.merge(options))
  end

  def a_pull_request
    { "id" => "42766810",
      "html_url" => "https://github.com/concordia-publishing-house/test/pull/1",
      "number" => "1",
      "state" => "open",
      "locked" => false,
      "title" => "[skip] Put something in the README (1m)",
      "user" => { "login" => "boblail" },
      "body" => "",
      "created_at" => "2015-08-19T01:03:43Z",
      "updated_at" => "2015-08-19T01:03:43Z",
      "closed_at" => nil,
      "merged_at" => nil,
      "merge_commit_sha" => nil,
      "assignee" => nil,
      "milestone" => nil,
      "head" => {
        "label" => "concordia-publishing-house:branch",
        "ref" => "branch",
        "sha" => "4e44fa43a06580b07820e1947b1c209880de1f84",
        "repo"=>{
          "id" => "41005299",
          "name" => "test",
          "full_name" => "concordia-publishing-house/test",
          "private" => false } },
      "base" => {
        "label" => "concordia-publishing-house:master",
        "ref" => "master",
        "sha" => "f478de5e6b8e42882b139a0b2cee144d0a1b90a4",
        "repo"=>{
          "id" => "41005299",
          "name" => "test",
          "full_name" => "concordia-publishing-house/test",
          "private" => false } },
      "merged" => false,
      "mergeable" => nil }
  end

end
