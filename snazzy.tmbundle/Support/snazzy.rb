#!/usr/bin/env ruby
require 'pathname'
require 'ostruct'

raise 'Please set TM_NODE to point to the node executable.' if ENV['TM_NODE'].to_s == ''

def offences(file)
  file = Pathname.new(ENV['TM_FILEPATH'])
  node = Pathname.new(ENV['TM_NODE'])
  project = Pathname.new(ENV['TM_PROJECT_DIRECTORY'])
  standard = project.join('node_modules/.bin/standard')
  command = %(#{node} #{standard} #{file} 2>&1)
  rows = `#{command}`.split("\n")

  rows.map do |row|
    next unless row.strip.start_with?(file.to_s)
    data = row.strip.split(':')
    OpenStruct.new line: data[1], row: data[2], message: data[3].strip.gsub('`', "'").gsub(',', ' ')
  end.compact
end

def command(offences)
  icon = Pathname.new(ENV['TM_BUNDLE_SUPPORT']).join('sad.png').to_s.inspect
  args = []

  args << ["--clear-mark=#{icon}"]
  offences.each do |offence|
    args << "--set-mark=#{icon}:#{offence.message.inspect}"
    args << "--line=#{offence.line}"
  end

  args << ENV['TM_FILEPATH'].inspect
  cmd = "#{ENV['TM_MATE']} #{args.join(' ')}"
end

content = offences(ENV['TM_FILEPATH'])
if content.empty?
  STDERR.write 'Snazzy is pleased.'
else
  STDERR.write 'Looks like you can improve your code.'
end

cmd = command(content)
exec cmd
