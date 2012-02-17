## Avoin Ministeriö

Avoin Ministeriö -verkkopalvelu.

<http://avoinministerio.fi>

If you want more information about the project, drop us an email to main@avoinministerio.flowdock.com.

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

    `cd avoinministerio`
    
    `bundle install`

    in development you might want to also pass `--without production`

5. Create database.yml in the config folder by copying database.example.yml and modifying it

    `cp config/database.example.yml config/database.yml`

6. Setup the database (create DB, load schema, load seed data)

    `rake db:setup`

7. Start the app

    `rails s`

## Development process

1. Fork the repository in Github

2. Clone your fork and setup the remote repository

        git clone git@github.com:<username>/avoinministerio.git
        cd avoinministerio
        git remote add avoinministerio git@github.com:avoinministerio/avoinministerio.git
        git remote set-url avoinministerio git@github.com:avoinministerio/avoinministerio.git

3. Create a feature branch

        git push origin origin:refs/heads/new-feature
        git fetch origin
        git checkout --track -b new-feature origin/new-feature
        git pull

4. Hack, commit and push your feature. Tests too :)

        git add .
        git commit -m "Commit message"
        git push

5. Pull and rebase the upstream repository

        git pull avoinministerio master
        git checkout new-feature
        git rebase master
        # fix possible conflicts
        git push

6. Create a pull request in Github

        https://github.com/<username>/avoinministerio/pull/new/new-feature

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
