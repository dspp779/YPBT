# frozen_string_literal: true
# call library files
files = Dir.glob(File.join(File.dirname(__FILE__), 'YPBT/*.rb'))
files.each { |lib| load lib }
