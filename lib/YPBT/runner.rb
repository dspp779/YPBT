# frozen_string_literal: true

module YoutubeVideo
  # Executable code for file(s) in bin/ folder
  class Runner
    def self.run!(args)
      video_id = args[0] || ENV['YT_VIDEO_ID']
      unless video_id
        puts 'USAGE: YPBT [video_id]'
        exit(1)
      end

      video = YoutubeVideo::Video.find(video_id: video_id)

      output_info(video)
    end

    def self.output_info(video)
      title = video.title
      separator = Array.new(video.title.length) { '-' }.join
      video_info =
        video.comments.map.with_index do |comment, index|
          comment_info(comment, index)
        end.join

      [title, separator, video_info].join("\n")
    end

    def self.comment_info(comment, index)
      "#{index + 1}:\n"\
      "  Author: #{comment.author.author_name}\n"\
      "  Comment: #{comment.text_display}\n"\
      "  LIKE: #{comment.author.like_count}\n"\
      "  AuthorChannelUrl: #{comment.author.author_channel_url}\n"
    end
  end
end
