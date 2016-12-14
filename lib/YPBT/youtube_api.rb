# frozen_string_literal: true
require 'http'
require 'json'

module YoutubeVideo
  # Service for all Youtube API calls
  class YtApi
    YT_URL = 'https://www.googleapis.com'
    YT_COMPANY = 'youtube'
    YT_COMPANY_URL = URI.join(YT_URL, "#{YT_COMPANY}/")
    API_VER = 'v3'
    YT_API_URL = URI.join(YT_COMPANY_URL, "#{API_VER}/")
    TIME_TAG_PATTERN = /http.+?youtube.+?\?.+?t=.+?\>([0-9:]+)<\/a>/
    def self.api_key
      return @api_key if @api_key
      @api_key = ENV['YOUTUBE_API_KEY']
    end

    def self.config=(credentials)
      @config ? @config.update(credentials) : @config = credentials
    end

    def self.video_info(video_id)
      field = 'items(id,'\
              'snippet(thumbnails(medium),channelId,description,'\
              'publishedAt,title,categoryId),'\
              'statistics(likeCount,dislikeCount,viewCount),'\
              'contentDetails(duration))'
      video_response = HTTP.get(yt_resource_url('videos'),
                                params: { id:     video_id,
                                          key:    api_key,
                                          part:   'snippet,statistics,
                                                    contentDetails',
                                          fields: field })
      JSON.parse(video_response.to_s)['items'].first
    end

    def self.popular_videos_info(max_results = 25)
      field = 'items(id,'\
              'snippet(thumbnails(medium),channelId,description,'\
              'publishedAt,title,categoryId),'\
              'statistics(likeCount,dislikeCount,viewCount),'\
              'contentDetails(duration))'
      video_response = HTTP.get(yt_resource_url('videos'),
                                params: { chart:     'mostpopular',
                                          key:    api_key,
                                          maxResults: max_results,
                                          part:   'snippet,statistics,
                                                    contentDetails',
                                          fields: field })
      JSON.parse(video_response.to_s)['items']
    end

    def self.comment_info(comment_id)
      comment_response = HTTP.get(yt_resource_url('comments'),
                                  params: { id: comment_id,
                                            key: api_key,
                                            part: 'snippet' })
      item = JSON.parse(comment_response.to_s)['items'].first
      comment = item['snippet']
      comment['id'] = comment_id
      comment
    end

    def self.video_comments_info(video_id, page_token = '', max_results = 100)
      comment_threads_response = HTTP.get(yt_resource_url('commentThreads'),
                                          params: { videoId:  video_id,
                                                    key:      api_key,
                                                    order:    'relevance',
                                                    part:     'snippet',
                                                    maxResults: max_results,
                                                    pageToken: page_token })
      comment_threads = JSON.parse(comment_threads_response.to_s)
      comments = extract_comment(comment_threads)
      next_page_token = comment_threads['nextPageToken']
      [next_page_token, comments]
    end

    def self.channel_info(channel_id)
      fields = 'items(id,snippet(title,description,thumbnails(default(url))))'
      channel_response = HTTP.get(yt_resource_url('channels'),
                                  params: {   id:     channel_id,
                                              key:    api_key,
                                              part:   'snippet',
                                              fields: fields })
      channel_data = JSON.parse(channel_response.to_s)['items'].first
      if channel_data
        {
          'title' => channel_data['snippet']['title'],
          'description' => channel_data['snippet']['description'],
          'image_url' => channel_data['snippet']['thumbnails']['default']['url']
        }
      end
    end

    def self.extract_comment(comment_threads)
      comments = comment_threads['items'].map do |item|
        comment = item['snippet']['topLevelComment']['snippet']
        comment['id'] = item['id']
        comment
      end
      comments
    end

    def self.time_tags_info(video_id, max_search_time = 5)
      next_page = ''
      comments_with_tags = []
      max_search_time.times do
        next_page, tmp_comments = video_comments_info(video_id, next_page)
        tmp_comments.each do |comment|
          comments_with_tags.push(comment) if time_tag? comment
        end
        break unless next_page
      end
      comments_with_tags
    end

    def self.time_tag?(comment)
      !(comment['textDisplay'] =~ TIME_TAG_PATTERN).nil?
    end

    private_class_method
    def self.yt_resource_url(resouce_name)
      URI.join(YT_API_URL, resouce_name.to_s)
    end
  end
end
