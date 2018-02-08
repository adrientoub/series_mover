#! /usr/bin/env ruby
require 'fileutils'
require 'logger'
require 'digest'

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
    FileUtils.mkdir_p(start_path + folder, options) unless File.directory?(start_path + folder)
    source = start_path + filename
    dest = start_path + folder + filename
    if File.exist?(dest)
      logger.warn "#{dest} already exists"
      shadest = Digest::SHA256.file(dest).hexdigest
      shasource = Digest::SHA256.file(source).hexdigest
      if shadest == shasource
        logger.warn "hash of file is #{shadest}"
        FileUtils.rm(source, options)
      else
        logger.warn "sha256 are: #{shadest} #{shasource}"
      end
    else
      FileUtils.mv(source, dest, options)
    end
  else
    logger.info "Ignored #{filename}" unless File.directory?(start_path + filename)
  end
end

