# frozen_string_literal: true
require_relative 'spec_helper.rb'

describe 'comment specifications' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock

    c.filter_sensitive_data('<API_KEY>') { ENV['YOUTUBE_API_KEY'] }
    c.filter_sensitive_data('<API_KEY_ESCAPED>') do
      URI.escape(ENV['YOUTUBE_API_KEY'])
    end
  end

  before do
    VCR.insert_cassette CASSETTE_FILE, record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'comment functions' do
    it 'should has the abilit to find by comment id' do
      comment = YoutubeVideo::Comment.find(comment_id: TEST_COMMENT_ID)
      comment.must_be_instance_of YoutubeVideo::Comment
      comment.comment_id.must_equal TEST_COMMENT_ID
    end
  end
end
