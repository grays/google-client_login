Gem::Specification.new do |spec|
  spec.name        = 'google-client_login'
  spec.version     = '1.1.4'
  spec.authors     = ['Jason L Perry']
  spec.date        = '2011-09-03'
  spec.summary     = 'Google ClientLogin authentication'
  spec.description = 'A simple library for authenticating against the Google ClientLogin API'
  spec.email       = 'jasper@ambethia.com'
  spec.homepage    = 'http://github.com/ambethia/google-client_login'

  spec.extra_rdoc_files = [
     "LICENSE",
     "README.rdoc"
  ]
  spec.files = [
     "README.rdoc",
     "lib/google-client_login.rb",
     "lib/google/client_login.rb"
  ]
  spec.require_paths = %w[lib]
  spec.test_files    = %w[test/google/client_login_test.rb]

  spec.add_development_dependency 'shoulda'
  spec.add_development_dependency 'mocha'
end

