# frozen_string_literal: true
require_relative 'comment'
require_relative 'youtube_api'
require_relative 'author'

module YoutubeVideo
  # signle comment on video's comment threads
  class Comment
    attr_reader :comment_id, :updated_at, :text_display, :published_at, :author

    def initialize(data: nil)
      load_data(data)
    end

    def self.find(comment_id:)
      comment_data = YoutubeVideo::YtApi.comment_info(comment_id)
      new(data: comment_data)
    end

    private

    def load_data(comment_data)
      @comment_id = comment_data['id']
      @updated_at = comment_data['updateAt']
      @text_display = comment_data['textDisplay']
      @published_at = comment_data['publishedAt']
      @author = YoutubeVideo::Author.new(comment_data)
    end

  end
end
