# Youtube Progress Bar Tagger
[![Gem Version](https://badge.fury.io/rb/YPBT.svg)](https://badge.fury.io/rb/YPBT)
[![Build Status](https://travis-ci.org/RubyStarts3/YPBT.svg?branch=master)](https://travis-ci.org/RubyStarts3/YPBT)

Youtube Progress Bar Tagger (YPBT) is a gem that tracks the comments following a youtube movie and captures the time points of popularity.

## Installation

If you are working on a project, add this to your Gemfile: `gem 'YPBT'`

For ad hoc installation from command line:

`$ gem install YPBT`

## Quick Start  
Export your [Youtube api key](https://console.developers.google.com/apis/credentials)  
  ```
    $ export YOUTUBE_API_KEY='Your_Youtube_API_Key'
  ```
Install essential gem  
  ```
    $ bundle install
  ```
Then do a basic test for our module  
  ```
    $ rake spec
  ```
Now, try to extract data from YouTube's video
=> `https://www.youtube.com/watch?v=[video_id]`
```
    $ YPBT [video_id]
```
## Usage
```ruby
video = YoutubeVideo::Video.find(
  video_id: video_id
)

puts video.title

video.commentthreads.each. do |comment|
  puts comment.author.author_name
  puts comment.text_display
  puts comment.author.like_count if comment.author.like_count
  puts comment.author.author_channel_url
end
```
