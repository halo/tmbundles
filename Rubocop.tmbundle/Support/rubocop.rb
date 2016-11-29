#!/usr/bin/env ruby

begin
  require 'rubocop'
rescue LoadError
  puts "Install rubocop!\ngem install rubocop"
  exit 1
end

def log(msg)
  require 'logger'
  logger = Logger.new('/tmp/rubocop_bundle.log')
  logger.info msg
end

def offences(file)
  ruby_version = RUBY_VERSION.split('.')[0..1].join('.').to_f

  config_file = RuboCop::ConfigLoader.configuration_file_for file
  Dir.chdir File.dirname(config_file)

  config = RuboCop::ConfigStore.new.for(file)

  team = RuboCop::Cop::Team.new(
    RuboCop::Cop::Cop.all,
    config,
    {}
  )

  processed_source = RuboCop::ProcessedSource.from_file(file, ruby_version)
  team.inspect_file(processed_source)
end

def messages(offences)
  messages = {
    refactor: {},
    convention: {},
    warning: {},
    error: {},
    fatal: {}
  }
  offences.each do |offence|
    message = messages[offence.severity.name][offence.line] ||= []
    message << offence.message.gsub('`', "'").gsub(',', ' ')
  end
  messages
end

def command(messages)
  icons = {
    refactor:   "#{ENV['TM_BUNDLE_SUPPORT']}/rubocop.pdf".inspect,
    convention: "#{ENV['TM_BUNDLE_SUPPORT']}/rubocop.pdf".inspect,
    warning:    "#{ENV['TM_BUNDLE_SUPPORT']}/rubocop.pdf".inspect,
    error:      "#{ENV['TM_BUNDLE_SUPPORT']}/rubocop.pdf".inspect,
    fatal:      "#{ENV['TM_BUNDLE_SUPPORT']}/rubocop.pdf".inspect
  }
  args = []

  messages.each do |severity, messages|
    args << ["--clear-mark=#{icons[severity]}"]
    messages.each do |line, message|
      args << "--set-mark=#{icons[severity]}:#{message.uniq.join(' ').inspect}"
      args << "--line=#{line}"
    end
  end

  args << ENV['TM_FILEPATH'].inspect

  "#{ENV['TM_MATE']} #{args.join(' ')}"
end

content = messages(offences(ENV['TM_FILEPATH']))
if content.values.all?(&:empty?)
  STDERR.write 'Rubocop is pleased.'
else
  STDERR.write 'Looks like you can improve your code.'
end

cmd = command(content)
# log cmd
exec cmd
