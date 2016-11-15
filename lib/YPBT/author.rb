# frozen_string_literal: tru
module YoutubeVideo
  # comment's author infomation
  class Author
    attr_reader :author_name, :author_image_url, :author_channel_url,
                :like_count
    def initialize(data)
      return unless data
      @author_name = data['authorDisplayName']
      @author_image_url = data['authorProfileImageUrl']
      @author_channel_url = data['authorChannelUrl']
      @like_count = data['likeCount'].to_i
    end
  end
end
