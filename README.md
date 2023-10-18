# README

## Context

In this exercise we will develop the building blocks of a **remote abnormality and fall detection system** to assist older persons.

One of the main problems facing the public health is the injury that happens due to older persons falling. Fast and proper medical interventions are crucial to reduce the serious consequences on their health.

To help with this issue, we build a prototype system where health centers can provide their patients with a device that continuously monitor vital signs and motion to automatically detect abnormal vital signs and fall of unattended older person. On detection, the device sends an alert to our system. Upon receiving the alert, the system notifies one of the caregivers attached to the center.

## SetUp Notes

#### Relevant versions:

- Ruby 3.2.2
- Rails 7.0.8
- PostgreSQL 13.12

#### Summary

I'm using MAC OS and rbenv as my ruby version manager. I followed an *[installation guide](https://gorails.com/setup/macos/10.14-mojave)* which summarize in the following commands:

```
brew install rbenv ruby-build
rbenv init
rbenv install 3.2.2
rbenv global 3.2.2
gem install bundler
gem install rails -v 7.0.6
brew install postgresql@13
echo 'export PATH="/opt/homebrew/opt/postgresql@13/bin:$PATH"' >> ~/.zshrc
brew services start postgresql@13
```

I think the app should run fine with another PostgreSQL version, in case you have already another version installed.

For starting the app, please go to the app's folder and run:

```
rails db:create
rails db:seed
bundle install
rails g rspec:install
rails s
```

Which should display a Rails image at <http://127.0.0.1:3000>. If you have problem with the default port, start the server using `rails server --binding=127.0.0.1` instead of `rails s`.

The command `rails db:create` creates a PostgreSQL DB named `fall_detection_system_development`.

To run all tests, please use the command `bundle exec rspec`.




===

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
