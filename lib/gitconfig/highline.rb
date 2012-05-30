require 'gitconfig'
require 'highline'

class GitConfig
  def highline
    @highline ||= HighLine.new
  end

  def ask(desc, default=nil)
    highline.ask("#{desc}? ") { |q| q.default = default }
  end
end
