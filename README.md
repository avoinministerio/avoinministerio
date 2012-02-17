## Avoin Ministeriö

Avoin Ministeriö -verkkopalvelu.

<http://avoinministerio.fi>

## Installation

1. Clone the repository

    `git clone git@github.com:avoinministerio/avoinministerio`

2. .rvmrc

It might be a good idea to use .rvmrc file to set ruby environment

    w168:avoinministerio arttu$ cat .rvmrc
    rvm use 1.9.3-p125@avoinministerio --create
    w168:avoinministerio arttu$

This way you will always be running the same ruby version with a defined gemset under this directory.

3. Check that you have the right ruby version (1.9.X)

4. Install the required gems

    `bundle install`

    in development you might want to also pass `--without production`

5. Create database.yml in the config folder by copying database.example.yml

6. Setup the database (create DB, load schema, load seed data)

    `rake db:setup`

7. Start the app

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

[Git repository](http://github.com/avoinministerio/avoinministerio)

Everything is currently in the master branch. When building bigger features, use feature branches. When the feature is ready, delete the feature branch.
