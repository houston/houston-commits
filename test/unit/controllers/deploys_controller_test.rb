require "test_helper"


class DeploysControllerTest < ActionController::TestCase
  tests Houston::Commits::DeploysController

  setup do
    @routes = Houston::Commits::Engine.routes
    @project = create(:project)
    @environment = "production"
    Timecop.freeze
  end

  teardown do
    Timecop.return
  end


  should "not require a logged in user" do
    mock(Deploy).create!(project: @project, environment_name: @environment, sha: "hi", branch: nil, deployer: nil, duration: nil, successful: true, completed_at: Time.now)
    post :create, params: { project_id: @project.slug, environment: @environment, commit: "hi" }
  end


  should "work with a Heroku-style deploy hook" do
    mock(Deploy).create!(project: @project, environment_name: @environment, sha: "hi", branch: nil, deployer: "deployer@heroku.com", duration: nil, successful: true, completed_at: Time.now)
    post :create, params: { project_id: @project.slug, environment: @environment, head_long: "hi", user: "deployer@heroku.com" }
  end


  should "work with title-cased environments" do
    mock(Deploy).create!(project: @project, environment_name: @environment, sha: "hi", branch: nil, deployer: nil, duration: nil, successful: true, completed_at: Time.now)
    post :create, params: { project_id: @project.slug, environment: "Production", commit: "hi" }
  end

  should "work with lowercased environments" do
    mock(Deploy).create!(project: @project, environment_name: @environment, sha: "hi", branch: nil, deployer: nil, duration: nil, successful: true, completed_at: Time.now)
    post :create, params: { project_id: @project.slug, environment: "production", commit: "hi" }
  end


  should "record the deployer if it is supplied" do
    mock(Deploy).create!(project: @project, environment_name: @environment, sha: "hi", branch: nil, deployer: "Bob Lail <bob.lail@cph.org>", duration: nil, successful: true, completed_at: Time.now)
    post :create, params: { project_id: @project.slug, environment: @environment, commit: "hi", deployer: "Bob Lail <bob.lail@cph.org>" }
  end


end
