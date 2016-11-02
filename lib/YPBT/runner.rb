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
      [
        "#{index + 1}: ",
        author_name_output(comment.author.author_name) + ':\n',
        text_display_output(comment.text_display) + '\n',
        'LIKE: ' + like_count_output(comment.author.like_count) + '\n',
        'AuthorChannelUrl: ' + \
         author_channel_url_output(comment.author.author_channel_url),
          '\n\n'
      ].join
    end

    def self.author_name_output(author_name)
      author_name ? author_name : '(blank)'
    end

    def self.text_display_output(text_display)
      text_display ? text_display : '(blank)'
    end

    def self.like_count_output(like_count)
      like_count ? like_count.to_s : '(blank)'
    end

    def self.author_channel_url_output(author_channel_url)
      author_channel_url ? author_channel_url.to_s : '(none)'
    end
  end
end
