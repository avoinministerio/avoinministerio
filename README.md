## Avoin Ministeriö

Avoin Ministeriö -verkkopalvelu.

<http://avoinministerio.fi>

If you want more information about the project, drop us an email to main@avoinministerio.flowdock.com.

## Installation

1. Clone the repository

        git clone git@github.com:avoinministerio/avoinministerio

2. .rvmrc

    It might be a good idea to use .rvmrc file to set ruby environment

        w168:avoinministerio arttu$ cat .rvmrc
        rvm use 1.9.3-p125@avoinministerio --create
        w168:avoinministerio arttu$

    This way you will always be running the same ruby version with a defined gemset under this directory.

3. Check that you have the right ruby version (1.9.X)

4. Install the required gems

        cd avoinministerio
        bundle install --without production:linux_test

    if you are developing on Linux replace `linux_test` with `mac_test`

5. Create database.yml in the config folder by copying database.yml.example and modifying it

        cp config/database.yml.example config/database.yml

6. Setup the database (create DB, load schema, load seed data)

        bundle exec rake db:setup

7. Start the app

        bundle exec rails s

## Post installation

Run tests with:

    bundle exec rake db:test:prepare
    bundle exec rake spec

## Development process

1. Fork the repository in Github

2. Clone your fork and setup the remote repository

        git clone git@github.com:<username>/avoinministerio.git
        cd avoinministerio
        git remote add avoinministerio git@github.com:avoinministerio/avoinministerio.git

3. Create a feature branch

        # The first two commands are not needed if you just cloned, but they don't hurt you either
        git checkout master
        git pull avoinministerio master
        git push     # to push commits from avoinministerio/master to your fork's master
        git push origin origin:refs/heads/new-feature
        git fetch origin
        git checkout --track -b new-feature origin/new-feature
        git pull
        git rebase master

4. Hack, commit and push your feature. Tests too :)

        # Before adding and committing, it is a good practice to run tests
        bundle exec rake spec

        git add .
        git commit -m "Commit message"
        git push

5. Pull and rebase the upstream repository

        git checkout master
        git pull avoinministerio master
        git checkout new-feature
        git rebase master
        # fix possible conflicts
        git push

6. Run tests to confirm your tests work with rebased master

        bundle install
        bundle exec rake db:migrate db:test:prepare
        bundle exec rake spec

7. Create a pull request in Github

        https://github.com/<username>/avoinministerio/pull/new/new-feature

## Deployment

To create your personal instance on [Heroku](http://www.heroku.com/):

1. Set up [Heroku account](http://devcenter.heroku.com/articles/quickstart)

2. Create and configure your own instance

        heroku create --stack cedar
        heroku config:add BUNDLE_WITHOUT="development:test:mac_test:linux_test" -r heroku

3. Initial deployment

        git push heroku master

4. Initialize database with test data

        heroku run rake db:setup

You can deploy whatever branch/commit by

    git push heroku +<local_ref>:master
    # e.g. the currently checked out branch
    git push heroku +HEAD:master

## Dependencies

**JS Libraries**

* jQuery
* Raphael (http://raphaeljs.com/)
* gRaphael (http://g.raphaeljs.com/)

**Other**

* Ruby 1.9.X

## Tests

Run the tests using the following command(s):

`rspec spec` or `bundle exec rspec spec`

## Code Repository

[Git repository](http://github.com/avoinministerio/avoinministerio)

Everything is currently in the master branch. When building bigger features, use feature branches. When the feature is ready, delete the feature branch.
