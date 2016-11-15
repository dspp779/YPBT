# frozen_string_literal: true
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'YPBT/version'

Gem::Specification.new do |s|
  s.name        =  'YPBT'
  s.version     =  YoutubeVideo::VERSION

  s.summary     =  'Gets comment from public Youtube videos'
  s.description =  'Youtube Progress Bar Tagger'\
                   'extracts comment threads, comments, and '\
                   'comment of author from Youtube videos'
  s.authors     =  ['Yi-Min'], ['Yuan-Yu'], ['Kun-Lin']
  s.email       =  ['b37582000@gmail.com'], ['tearsgundam@gmail.com'],
                   ['orange6318@hotmail.com']

  s.files       =  `git ls-files`.split("\n")
  s.test_files  =  `git ls-files -- spec/*`.split("\n")
  s.executables << 'YPBT'

  s.add_runtime_dependency 'http', '~> 2.0'
  s.add_runtime_dependency 'ruby-duration', '~>3.2.3'
  s.add_development_dependency 'minitest', '~> 5.9'
  s.add_development_dependency 'minitest-rg', '~> 5.2'
  s.add_development_dependency 'rake', '~> 11.3'
  s.add_development_dependency 'vcr', '~> 3.0'
  s.add_development_dependency 'webmock', '~> 2.1'
  s.add_development_dependency 'simplecov', '~> 0.12'
  s.add_development_dependency 'flog', '~> 4.4'
  s.add_development_dependency 'flay', '~> 2.8'
  s.add_development_dependency 'rubocop', '~> 0.42'
  s.homepage    =  'https://github.com/RubyStarts3/YPBT'
  s.license     =  'MIT'
end
