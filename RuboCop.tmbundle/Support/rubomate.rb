require "#{ENV['TM_RUBY_BUNDLE_SUPPORT']}/lib/executable"
require "#{ENV['TM_SUPPORT_PATH']}/lib/tm/executor"
require "#{ENV['TM_SUPPORT_PATH']}/lib/ui"

class RuboMate
  def self.run(&block)
    Dir.chdir(ENV['TM_PROJECT_DIRECTORY'])

    if executable
      new.run(&block)
    else
      yield false
    end
  end

  def self.executable
    Executable.find 'rubocop'
  end

  def self.autocorrect?
    ARGV.first == 'autocorrect'
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
    result = %w[--format clang --display-cop-names --force-exclusion]
    result << '--auto-correct' if self.class.autocorrect?
    result
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
    TextMate::Executor.run(self.class.executable, paths, options) do |line, _|
      offence_count = $1.to_i if line =~ /(\d+|no) offenses? detected/
      nil # <- Passing on stdout to the Executor, it can read clang and add line marks.
    end

    yield offence_count
  end
end

RuboMate.run do |offence_count|
  case offence_count
  when false
    TextMate::UI.tool_tip("Could not find rubocop executable, please set TM_RUBOCOP")
  when 0
    # Be slient if there were no offences
  else
    if RuboMate.autocorrect?
      TextMate::UI.tool_tip 'I fixed your stuff'
    else
      TextMate::UI.tool_tip 'Looks like you can improve your code'
    end
  end
end
