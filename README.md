## Avoin Ministeriö

Avoin Ministeriö -verkkopalvelu.

<http://avoinministerio.fi>

## Installation

1. Clone the repository

    `git clone git@github.com:kiskolabs/avoinministerio`

2. Check that you have the right ruby version (1.9.X)

3. Install the required gems

    `bundle install`

    in development you might want to also pass `--without production`

4. Create database.yml in the config folder by copying database.example.yml

5. Setup the database (create DB, load schema, load seed data)

    `rake db:setup`

6. Start the app

    `rails s`

## Deployment

Undecided, probably Capistrano.

## Dependencies

**JS Libraries**

* jQuery

**Other**

* Ruby 1.9.X

## Tests

Run the tests using the following command(s):

`rspec spec` or `bundle exec rspec spec`

## Code Repository

[Git repository](http://github.com/kiskolabs/avoinministerio)

Everything is currently in the master branch. When building bigger features, use feature branches. When the feature is ready, delete the feature branch.

## Project management

Undecided, maybe Pivotal Tracker
