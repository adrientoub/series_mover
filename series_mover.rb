#! /usr/bin/env ruby
require 'fileutils'
require 'logger'

if ARGV.empty?
  $stderr.puts 'Usage: ./movefiles.rb [PATH]'
  exit 1
end

options = { verbose: true, noop: true }

files = []
start_path = ARGV[0]
if start_path[-1] != '/'
  start_path += '/'
end
if !ARGV[1].nil? && ARGV[1] == '-f'
  options = { verbose: true }
end

logger = Logger.new(STDOUT)

Dir.new(start_path).each do |filename|
  files << filename
  if filename =~ /(.+).S([0-9]{2})E([0-9]{2})(.+)/
    series_name = $1.split('.').join(' ')
    season = $2
    folder = "#{series_name}/Season #{season}/"
    FileUtils.mkdir_p(start_path + folder, options)
    FileUtils.mv(start_path + filename, start_path + folder + filename, options)
  else
    logger.info "Ignored #{filename}"
  end
end

