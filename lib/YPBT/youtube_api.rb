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

    def self.api_key
      return @api_key if @api_key
      @api_key = ENV['YOUTUBE_API_KEY']
    end

    def self.config=(credentials)
      @config ? @config.update(credentials) : @config = credentials
    end

    def self.config
      return @config if @config
      @config = { api_key:     ENV['YOUTUBE_API_KEY'] }
    end
    
    def self.video_info(video_id)
      field = 'items(id,snippet(channelId,description,publishedAt,title))'
      video_response = HTTP.get(yt_resource_url('videos'),
                                params: { id:     video_id,
                                          key:    api_key,
                                          part:   'snippet',
                                          fields: field })
      JSON.parse(video_response.to_s)['items'].first
    end

    def self.video_commentthreads_info(video_id)
      comment_threads_response = HTTP.get(yt_resource_url('commentThreads'),
                                          params: { videoId:  video_id,
                                                    key:      api_key,
                                                    order:    'relevance',
                                                    part:     'snippet' })
      JSON.parse(comment_threads_response.to_s)['items']
    end

    def self.comment_info(comment_id)
      comment_response = HTTP.get(yt_resource_url('comments'),
                                  params: { id: comment_id,
                                            key: api_key,
                                            part: 'snippet' })
      JSON.parse(comment_response.to_s)['items'][0]
    end

    def self.authors_info(comment_id)
      field = 'items(snippet(authorChannelId,authorChannelUrl,'\
      'authorDisplayName,authorProfileImageUrl,likeCount))'
      authors_response = HTTP.get(yt_resource_url('comments'),
                                  params: { id: comment_id,
                                            key: api_key,
                                            part: 'snippet',
                                            fields: field })
      JSON.parse(authors_response.to_s)['items']
    end
    private_class_method
    def self.yt_resource_url(resouce_name)
      URI.join(YT_API_URL, resouce_name.to_s)
    end
  end
end
