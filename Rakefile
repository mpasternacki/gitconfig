#!/usr/bin/env rake

require 'bundler/gem_helper'

namespace :gitconfig do
  Bundler::GemHelper.install_tasks(:name => 'gitconfig')
end

namespace 'gitconfig-highline' do
  gh = Bundler::GemHelper.new(Dir.pwd, 'gitconfig-highline')

  # make it use different tag, otherwise git's complaining.
  class << gh
    def version_tag
      "v#{version}-hl"
    end
  end
  gh.install
end

%w(build install release).each do |task_name|
  desc "#{task_name.capitalize} both gems"
  task task_name => [
    "gitconfig:#{task_name}", "gitconfig-highline:#{task_name}" ]
end
