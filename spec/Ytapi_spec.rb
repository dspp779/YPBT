# frozen_string_literal: true
require_relative 'spec_helper.rb'

describe 'YtApi specifications' do
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
  end

  describe 'YtApi functions' do
    it 'should be able to find video by video id' do
      YoutubeVideo::YtApi.video_info(TEST_VIDEO_ID).must_be_instance_of Hash
    end

    it 'should be able find comment by comment id' do
      result = YoutubeVideo::YtApi.comment_info(TEST_COMMENT_ID)
      result.must_be_instance_of Hash
      result['id'].must_equal TEST_COMMENT_ID
    end

    it 'should be able find comments by video id' do
      next_page_token, comments = YoutubeVideo::YtApi
                                  .video_comments_info(TEST_VIDEO_ID)
      next_page_token.must_be_instance_of String
      comments.must_be_instance_of Array
      comments.length.must_be :>, 1
      comments[0].must_be_instance_of Hash
    end

    it 'should be able find comments that contain time tags by video_id' do
      comments = YoutubeVideo::YtApi.time_tags_info(TEST_VIDEO_ID)
      comments.must_be_instance_of Array
      comments.length.must_be :>, 1
      comments[0].must_be_instance_of Hash
      comments[0]['textDisplay'].must_match(/[0-9]+:\d+/)
    end

    it 'should be able to resolve channel' do
      channel_info = YoutubeVideo::YtApi.channel_info(TEST_CHANEL_ID)
      channel_info.must_be_instance_of Hash
      channel_info['title'].length.must_be :>, 0
      channel_info['description'].length.must_be :>, 0
      channel_info['image_url'].must_match(/https:/)
    end

    it 'should be able to find popular videos' do
      popular_videos = YoutubeVideo::YtApi.popular_videos_info
      popular_videos.length.must_be :==, 25
    end
  end
end
