#! /usr/bin/ruby

require 'rubygems'
require 'optparse'
require 'pathname'

require File.expand_path('deploy/tasks', File.dirname(Pathname.new(__FILE__).realpath))
require File.expand_path('deploy/string_colorize', File.dirname(Pathname.new(__FILE__).realpath))
require File.expand_path('deploy/samfundet_paths', File.dirname(Pathname.new(__FILE__).realpath))

include Tasks
include SamfundetPaths

require File.expand_path('deploy/task_definitions', File.dirname(Pathname.new(__FILE__).realpath))

options = {}

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: ./deploy.rb [options]"

  shown_task_groups.each do |identifier, task_group|
    opts.on(task_identifier_to_option(identifier), task_group[:description]) do
      options[identifier] = true
    end
  end

  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end
end

begin
  optparse.parse!
rescue OptionParser::InvalidOption
  puts optparse
  exit
end

if options.empty?
  options = {
      :update_everything => true
  }
end

shown_task_groups.keys.each do |identifier|
  if options.has_key? identifier
    if execute_group identifier
      print "Would you like to restart the server? [y/n] "

      if gets.chomp == "y"
        execute_task(
            :description => "Restarting server..",
            :block => Proc.new {
              command "touch tmp/restart.txt"
            }
        )
      end
    end
  end
end
