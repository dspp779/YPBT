require 'ruby-duration'

module YoutubeVideo
  TAG_TYPES = { MUSIC: 'music', VIDEO: 'video' }.freeze
  # comment's time tag infomation
  class Timetag
    attr_reader :start_time, :end_time, :tag_type, :duration, :comment
    def initialize(start_time:, comment:, end_time: nil, like_count: nil,
                   tag_type: nil)
      @start_time = string_to_time start_time
      @end_time = end_time
      @like_count = like_count ? like_count : comment.like_count
      @tag_type = tag_type
    end

    def start_time
      @start_time&.iso8601
    end

    def end_time=(end_time)
      @end_time = string_to_time end_time if end_time
    end

    def end_time
      @end_time&.iso8601 if @end_time
    end

    def duration
      @duration = @end_time - @start_time if @end_time && @start_time
      @duration&.iso8601 if @duration
    end

    def tag_type=(tag_type)
      @tag_type = TAG_TYPES[tag_type.to_sym] if tag_type
    end

    def self.find(comment:)
      time_tag_pattern = /http.+?youtube.+?\?.+?t=.+?\>([0-9:]+)<\/a>/
      start_times_string = comment.text_display.scan time_tag_pattern
      tags = start_times_string.map do |match_parts|
        Timetag.new(start_time: match_parts[0], comment: comment)
      end
      tags
    end

    private

    def string_to_time(time_string)
      time_unit = [:seconds, :minutes, :hours, :day, :weeks]
      time_array = time_string.scan(/[0-9]+/).map(&:to_i).reverse
      Duration.new(Hash[time_unit.zip(time_array)])
    end
  end
end
