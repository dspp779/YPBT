# frozen_string_literal: true
require 'rake/testtask'

task default: :spec

namespace :credentials do
  require 'yaml'

  desc 'generate YOUTUBE_API_KEY to STDOUT'
  task :get_youtube_api_key do
    credentials = YAML.load(File.read('config/credentials.yml'))
    require_relative 'lib/YPBT/youtube_api'
    ENV['YOUTUBE_API_KEY'] = credentials[:YOUTUBE_API_KEY]

    puts "YOUTUBE_API_KEY: #{YoutubeVideo::YtApi.api_key}"
  end

  desc 'Export sample credentials from file to bash'
  task :export do
    credentials = YAML.load(File.read('config/credentials.yml'))
    puts 'Please run the following in bash:'
    puts "export YOUTUBE_API_KEY=#{credentials[:YOUTUBE_API_KEY]}"
  end
end

desc 'run tests'
Rake::TestTask.new(:spec) do |t|
  t.pattern = 'spec/*_spec.rb'
  t.warning = false
end

desc 'delete cassette fixtures'
task :wipe do
  sh 'rm spec/fixtures/cassettes/*.yml' do |ok, _|
    puts(ok ? 'Cassettes deleted' : 'No casseettes found')
  end
end

desc 'quality checks'

namespace :quality do
  desc 'run all quality checks'
  task all: [:rubocop, :flog, :flay]

  task :rubocop do
    sh 'rubocop'
  end

  task :flog do
    sh 'flog lib/*.rb'
    sh 'flog spec/*.rb'
  end

  task :flay do
    sh 'flay lib/*.rb'
    sh 'flay spec/*.rb'
  end
end
