require 'gitconfig/version'

require 'escape'
require 'git'

class GitConfig
  attr_reader :vars, :escaped

  def initialize(*args)
    opts = args.last.is_a?(Hash) ? args.pop : {}
    @git = Git.open(args[0]||'.', opts)
    @gitlib = Git::Lib.new(@git)

    @vars = opts[:vars] || {}
    @opts = opts
    @escaped = EscapedProxy.new(self)
  end

  def described_vars(*names)
    names = vars.keys if names.empty?
    Hash[ names.map { |k| [vars[k][:description] || k, self[k]] } ]
  end

  def defvar(name, meta=nil)
    vars[name] = meta
  end

  def ask(desc, default=nil)
    print "#{desc}? [#{default}] "
    response = gets.strip
    response = '' ? default : response
  end

  def [](key, opts={})
    opts = @opts.clone.update(opts)
    key = key.to_s

    if !(include?(key) || opts[:noninteractive])
      meta = vars[key] || {}
      default = meta[:default]
      default = default.call(key) if default.respond_to?(:call)
      meta[:description] ||= key
      self[key] = ask(desc, default)
    else
      self.to_hash[key]
    end
  end

  def []=(key, value)
    save_git_env { gitlib.config_set(key, value) }
    @as_hash = nil
    value
  end

  def include?(key)
    self.to_hash.include?(key)
  end

  def to_hash
    @as_hash ||= save_git_env { 
      gitlib.parse_config(File.join(git.repo.path, 'config'))
    }
  end

  private
  attr_reader :git, :gitlib

  def save_git_env
    dir = ENV['GIT_DIR']
    index_file = ENV['GIT_INDEX_FILE']
    work_tree = ENV['GIT_WORK_TREE']
    yield
  ensure
    if dir then ENV['GIT_DIR'] = dir else ENV.delete('GIT_DIR') end
    if index_file then ENV['GIT_INDEX_FILE'] = index_file else ENV.delete('GIT_INDEX_FILE') end
    if work_tree then ENV['GIT_WORK_TREE'] = work_tree else ENV.delete('GIT_WORK_TREE') end
  end

  class EscapedProxy
    instance_methods.each do |m|
      undef_method m unless m =~ /(^__|^send$|^object_id$)/
    end

    def initialize(target)
      @target = target
    end

    def [](*args)
      Escape.shell_single_word(@target[*args])
    end

    protected

    def method_missing(name, *args, &block)
      @target.send(name, *args, &block)
    end
  end
end
