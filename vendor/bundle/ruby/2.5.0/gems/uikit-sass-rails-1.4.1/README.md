# Uikit::Sass:Rails

[![Gem: Version 1.4](https://img.shields.io/gem/v/uikit-sass-rails.svg?style=flat-square)](https://rubygems.org/gems/uikit-sass-rails)
[![License: EUPL-1.1](https://img.shields.io/badge/license-EUPL--1.1-red.svg?style=flat-square)](https://github.com/cworreschk/uikit-sass-rails/blob/master/LICENSE.md)

Uikit::Sass:Rails is a gem to make it super easy to use UIkit in your Rails project. It is written in Sass and compatible with the asset pipeline in Rails. You can start using Uikit::Sass:Rails in your projects by following the instructions below.

## Installation

In Bundler:
```ruby
gem "uikit-sass-rails"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as::
```bash
$ [sudo|rvm] gem install uikit-sass-rails
```

### Add UIkit to your CSS

Append the following line to your `app/assets/stylesheets/application.css` file:
```css
/*= require uikit */
```

If you're planning on using Sass, then you'll want to rename `application.css` to `application.scss`. That file should then look like:
```css
@import "uikit";
```

### Add UIkit to your JS

Append the following line to your `app/assets/javascripts/application.js` file:
```javascript
//= require uikit
```

### Change UIkit Theme
If you don't want to use the default UIkit theme, just replace the uikit line in your `app/assets/stylesheets/application.css` file with one of the following lines:
```css
/*= require uikit */ /* Default Theme */
/*= require uikit/gradient */ /* Gradient Theme */
/*= require uikit/almost-flat */ /* Almost-Flat Theme */
```

In your `app/assets/stylesheets/application.scss` file just replace the uikit line with one of the following lines:
```scss
@import "uikit"; // Default Theme
@import "uikit/gradient"; // Gradient Theme
@import "uikit/almost-flat"; // Almost-Flat Theme
```

## Copyright and license
Copyright 2014 Christian Worreschk under the [European Union Public Licence V. 1.1](http://opensource.org/licenses/EUPL-1.1).

* [UIkit](http://www.getuikit.com) is created by [YOOtheme](http://www.yootheme.com) and licensed under the [MIT license](http://opensource.org/licenses/MIT).
* The [Font Awesome](http://fontawesome.io) font, which is used by UIkit, is created by [Dave Gandy](https://github.com/davegandy) and licensed under the [SIL OFL 1.1](http://scripts.sil.org/OFL).

##Versioning

Uikit::Sass::Rails will be maintained under the Semantic Versioning guidelines as much as possible. Releases will be numbered with the following format:

`<major>.<minor>.<patch>`

And constructed with the following guidelines:

* Breaking backward compatibility bumps the major (and resets the minor and patch)
* New additions, including new icons, without breaking backward compatibility bumps the minor (and resets the patch)
* Bug fixes and misc changes bumps the patch

For more information on SemVer, please visit http://semver.org.

## Contributing
Uikit::Sass:Rails follows the [GitFlow branching model](http://nvie.com/posts/a-successful-git-branching-model). The ```master``` branch always reflects a production-ready state while the latest development is taking place in the ```develop``` branch.

Each time you want to work on a fix or a new feature, create a new branch based on the ```develop``` branch: ```git checkout -b BRANCH_NAME develop```. Only pull requests to the ```develop``` branch will be merged.
