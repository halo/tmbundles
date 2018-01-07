require "#{ENV['TM_RUBY_BUNDLE_SUPPORT']}/lib/executable"
require "#{ENV['TM_SUPPORT_PATH']}/lib/tm/executor"
require "#{ENV['TM_SUPPORT_PATH']}/lib/ui"

class SassMate
  def self.run(&block)
    Dir.chdir(ENV['TM_PROJECT_DIRECTORY'])

    if executable && linter_executable
      new.run(&block)
    else
      yield false
    end
  end

  def self.executable
    Executable.find 'node'
  end

  def self.linter_executable
    Executable.find 'sass-lint'
  end

  def self.config_path
    config_file = Pathname.new(ENV['HOME']).join('.sass-lint.yml').expand_path
    raise "Expected to find config file #{config_file}" unless config_file.readable?
    config_file
  end

  def run(&block)
    pid = fork do
      STDOUT.reopen open('/dev/null', 'w')
      STDERR.reopen open('/dev/null', 'w')
      run!(&block)
    end
    Process.detach(pid)
  end

  private

  def paths
    Array(ENV['TM_FILEPATH'])
  end

  def arguments
    #self.class.linter_executable +

    %W[--verbose --format unix --no-exit --config #{self.class.config_path}]
  end

  # See https://github.com/textmate/bundle-support.tmbundle/blob/master/Support/shared/lib/tm/executor.rb
  def options
    {
      script_args: arguments,
      use_hashbang: false,
    }
  end

  def run!
    offence_count = nil
    TextMate::Executor.run(self.class.executable, self.class.linter_executable, paths, options) do |line, _|
      offence_count = Regexp.last_match(1).to_i if line.match?(/\./)
      nil # <- Passing on stdout to the Executor, it can read clang and add line marks.
    end

    yield offence_count
  end
end

SassMate.run do |offence_count|
  case offence_count
  when false
    TextMate::UI.tool_tip('Could not find node or sass-lint executable, please set TM_NODE and TM_SASS_LINT')
  when nil
    # Be slient if there were no offences
  else
    TextMate::UI.tool_tip 'Looks like you can improve your style.'
  end
end
