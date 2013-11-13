source 'https://rubygems.org'
gemspec

platforms :jruby do
  gem 'jruby-openssl'
end

def darwin_only(require_as)
  RUBY_PLATFORM.include?('darwin') && require_as
end

group :development do
  platforms :mri_19 do
    gem 'guard-yard'
    gem 'yard'
    gem 'redcarpet'
    gem 'guard'
    gem 'guard-rspec'
    gem 'pry'
  end
end

group :development, :test do
  if RUBY_PLATFORM.include? 'darwin'
    gem 'rb-fsevent', :require => darwin_only('rb-fsevent')
    gem 'growl', :require => darwin_only('growl')
  end
end
