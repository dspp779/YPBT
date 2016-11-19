# frozen_string_literal: true
require_relative 'comment'
require_relative 'youtube_api'

module YoutubeVideo
  # Main class to setup a Video
  class Video
    attr_reader :title, :description, :dislike_count, :like_count,
                :comment_count, :view_count, :duration, :id

    def initialize(data:)
      @id = data['id']
      @title = data['snippet']['title']
      @description = data['snippet']['description']
      @dislike_count = data['statistics']['dislikeCount'].to_i
      @like_count = data['statistics']['likeCount'].to_i
      @view_count = data['statistics']['viewCount'].to_i
      @duration = data['contentDetails']['duration']
    end

    def comments
      # contain only the comments which have time tag.
      return @comments if @comments
      raw_comments = YtApi.time_tags_info(@id)
      @comments = raw_comments.map { |comment| Comment.new(data: comment) }
    end

    def embed_url
      return @embed_url if @embed_url
      @embed_url = "https://www.youtube.com/embed/#{@id}"
    end

    def self.find(video_id:)
      video_data = YtApi.video_info(video_id)
      new(data: video_data) if video_data
    end
  end
end
