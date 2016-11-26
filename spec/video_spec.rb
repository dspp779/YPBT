# frozen_string_literal: true
require_relative 'spec_helper.rb'

describe 'Video specifications' do
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

  describe 'YtApi Credentials' do
    it 'should be able to get a new api key with ENV credentials' do
      YoutubeVideo::YtApi.api_key.length.must_be :>, 0
    end
    it 'should be able to get a new access token with file credentials' do
      YoutubeVideo::YtApi.config = { api_key: ENV['YOUTUBE_API_KEY'] }
    end

    it 'should be able to open a video' do
      video = YoutubeVideo::Video.find(
        video_id: TEST_VIDEO_ID
      )
      video.title.length.must_be :>, 0
      video.channel_id.length.must_be :>, 0
    end

    it 'should have comments' do
      video = YoutubeVideo::Video.find(video_id: TEST_VIDEO_ID)
      video.comments.length.must_be :>, 1
    end

    it 'should have channel information' do
      video = YoutubeVideo::Video.find(video_id: TEST_VIDEO_ID)
      video.title.length.must_be :>, 0
      video.channel_description.length.must_be :>, 0
      video.channel_image_url.must_match(/https:/)
    end

    it 'should run the executable file' do
      output = `YPBT #{TEST_VIDEO_ID}`
      output.split("\n").length.must_be :>, 5
    end
  end
end
