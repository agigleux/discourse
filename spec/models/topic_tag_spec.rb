# frozen_string_literal: true

describe TopicTag do

  fab!(:topic) { Fabricate(:topic) }
  fab!(:tag) { Fabricate(:tag) }
  let(:topic_tag) { Fabricate(:topic_tag, topic: topic, tag: tag) }

  context '#after_create' do

    it "tag topic_count should be increased" do
      expect {
        topic_tag
      }.to change(tag, :topic_count).by(1)
    end

    it "tag topic_count should not be increased" do
      topic.archetype = Archetype.private_message

      expect {
        topic_tag
      }.not_to change(tag, :topic_count)
    end

  end

  context '#after_destroy' do

    it "tag topic_count should be decreased" do
      topic_tag
      expect {
        topic_tag.destroy
      }.to change(tag, :topic_count).by(-1)
    end

    it "tag topic_count should not be decreased" do
      topic.archetype = Archetype.private_message
      topic_tag

      expect {
        topic_tag.destroy
      }.not_to change(tag, :topic_count)
    end

  end

end
