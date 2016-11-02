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
        video.commentthreads.first(3).map.with_index do |comment, index|
          comment_info(comment, index)
        end.join

      [title, separator, video_info].join("\n")
    end

    def self.comment_info(comment, index)
      <<~STRING
      #{index + 1}:
        Autor: #{comment.author.author_name}
        Comment: #{comment.text_display}
        LIKE: #{comment.author.like_count}
        AuthorChannelUrl: #{comment.author.author_channel_url}
      STRING
    end
  end
end
