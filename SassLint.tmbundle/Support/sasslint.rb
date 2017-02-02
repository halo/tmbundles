#!/usr/bin/env ruby
require 'pathname'
require 'open3'
require 'json'
require 'ostruct'
require 'shellwords'

icon_path = "#{ENV['TM_BUNDLE_SUPPORT']}/sass-logo.pdf".inspect
raise 'Please set TM_NODE to point to the node executable.' if ENV['TM_NODE'].to_s == ''

sass_lint = Pathname.new(ENV['TM_NODE']).dirname.join('sass-lint')
raise "Expeced to find executable #{sass_lint}" unless sass_lint.executable?

config_file = Pathname.new(ENV['HOME']).join('.sass-lint.yml')
raise "Expected to find config file #{config_file}" unless sass_lint.readable?

cmd = [
  ENV['TM_NODE'],
  sass_lint.to_s,
  '--config',
  config_file.to_s,
  '--verbose',
  '--format',
  'json',
  '--no-exit',
  ENV['TM_FILEPATH']
]

json, status = Open3.capture2(*cmd)
output = JSON.parse(json) rescue []

offences = output.first['messages'] rescue []

args = ["--clear-mark=#{icon_path}"]
offences.each do |offence|
  offence = OpenStruct.new(offence)
  message = "#{offence.message} (#{offence.ruleId})"

  args << "--set-mark=#{icon_path}:#{Shellwords.escape(message)}"
  args << "--line=#{offence['line']}"
end
args << ENV['TM_FILEPATH'].inspect
cmd = "#{ENV['TM_MATE']} #{args.join(' ')}"

if status.exitstatus.zero? && output == []
  STDERR.write 'Sass Linter is pleased.'
else
  STDERR.write 'Looks like you can improve your style.'
end

exec cmd
