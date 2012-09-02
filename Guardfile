
group :rspec do
  guard 'rspec', :version => 2, :cli => "--color --format nested" do
    watch(%r{^spec/(.+)_spec\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^spec/support/*})      { 'spec' }
    watch(%r{^lib/(.+)\.rb$})       { 'spec' }
    watch('spec/spec_helper.rb')    { "spec" }
  end
end

group :yard do
  guard 'yard', :port => '8088' do
    watch(%r{lib/.+\.rb})
    watch(%r{README.md})
    watch(%r{FUTURE_WORK.md})
    watch(%r{LICENSE})
  end
end
