# frozen_string_literal: true
require_relative 'spec_helper.rb'

describe 'time_tag specifications' do
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

  describe 'time_tag functions' do
    it 'should able find time tag from comment text' do
      comment = YoutubeVideo::Comment.find(comment_id: TEST_COMMENT_ID)
      tags = YoutubeVideo::Timetag.find(comment: comment)
      tags.must_be_instance_of Array
      tags.length.must_be :==, 3
    end
  end
end
