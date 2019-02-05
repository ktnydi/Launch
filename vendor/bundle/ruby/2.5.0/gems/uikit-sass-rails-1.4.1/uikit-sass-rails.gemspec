# -*- encoding: utf-8 -*-

$:.push File.expand_path('../lib', __FILE__)
require 'uikit/sass/rails/version'


Gem::Specification.new do |gem|
  gem.name        = 'uikit-sass-rails'
  gem.version     = Uikit::Sass::Rails::VERSION
  gem.date        = Time.now.strftime('%Y-%m-%d')
  gem.summary     = 'UIkit on Sass for Rails'
  gem.description = 'Uikit::Sass:Rails is a gem to make it super easy to use UIkit in your Rails project.'

  gem.authors  = ['Christian Worreschk']
  gem.email    = ['info@worreschk.eu']
  gem.homepage = 'http://github.com/cworreschk/uikit-sass-rails'
  gem.licenses  = ['EUPL-1.1']

  gem.require_paths = ['lib']
  gem.files         = `git ls-files`.split($/)
  gem.extra_rdoc_files = ['README.md', 'LICENSE.md', 'CHANGELOG.md']

  gem.add_runtime_dependency 'sass-rails', '>= 3.1'
end
