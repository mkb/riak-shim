#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rspec/core/rake_task"

task :default => :spec

desc "Run all specs"
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = ['--backtrace -cfs']
end

desc "Travis build checks for JRuby and adds a needed gem before testing"
task :travis => [:check_jruby, :spec]

desc "JRuby needs an additional gem"
task :check_jruby do
  if RUBY_PLATFORM == 'java'
    `gem install jruby-openssl`
  end
end

