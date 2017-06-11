require "test_helper"


class PostReceivePayloadTest < ActiveSupport::TestCase

  should "be able to parse JSON payloads from GitHub" do
    assert_equal "0d1a26e67d8f5eaf1f6ba5c57fc3c7d91ac0fd1c",
      PostReceivePayload.new(github_push_event_payload).sha
  end

  context "#to_h" do
    should "include sha, agent_email, and branch" do
      assert_equal({
        sha: "0d1a26e67d8f5eaf1f6ba5c57fc3c7d91ac0fd1c",
        agent_email: '"baxterthehacker" <baxterthehacker@users.noreply.github.com>',
        branch: "changes"
      }, PostReceivePayload.new(github_push_event_payload).to_h)
    end
  end

private

  def github_push_event_payload
    @github_push_event_payload ||= MultiJson.load(
      File.read("#{path}/data/github_push_event_payload.json"))
  end

end
