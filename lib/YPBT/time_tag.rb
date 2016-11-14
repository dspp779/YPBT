module YoutubeVideo
  # comment's author infomation
  class Timetag
    attr_reader :author_name, :author_image_url, :author_channel_url,
                :like_count
    def initialize(data)
      return unless data
      @start_time = data['authorDisplayName']
      @end_time = data['authorProfileImageUrl']
      @like_count = data['authorChannelUrl']
      @labal_type = data['likeCount'].to_i
      @duration = 'test'
    end

    def self.find(text_display:)
      
    end
  end
end
