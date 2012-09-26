## Avoin Ministeriö

Avoin Ministeriö -verkkopalvelu.

<https://www.avoinministerio.fi/>

If you want more information about the project, drop us an email to main@avoinministerio.flowdock.com.

## Installation

1. Clone the repository

        git clone git@github.com:avoinministerio/avoinministerio.git

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

6. Create a pre-commit hook that runs automated tests before each commit and keeps you from committing if some tests fail. Create a file called `pre-commit` in the `.git/hooks` directory, and copy this content to it:

        #!/usr/bin/env ruby
        require File.expand_path('../../../config/application', __FILE__)
        AvoinMinisterio::Application.load_tasks
        Rake.application["spec"].reenable
        Rake.application["spec"].invoke
    
    Also make the file executable:
    
        chmod +x .git/hooks/pre-commit
    
7. Setup the database (create DB, load schema, load seed data)

        bundle exec rake db:setup

8. Start the app

        bundle exec rails s

## Post installation

Run tests with:

    bundle exec rake db:test:prepare
    bundle exec rake spec

Run tests when RED-GREEN-REFACTOR:

    bundle exec guard

## Development process

1. Optionally read [unofficial Ruby style guidelines](http://www.caliban.org/ruby/rubyguide.shtml#style) before starting to write code

2. Fork the repository in Github

3. Clone your fork and setup the remote repository

        git clone git@github.com:<username>/avoinministerio.git
        cd avoinministerio
        git remote add avoinministerio git@github.com:avoinministerio/avoinministerio.git

4. Create a feature branch

        # The first two commands are not needed if you just cloned, but they don't hurt you either
        git checkout master
        git pull avoinministerio master
        git push     # to push commits from avoinministerio/master to your fork's master
        git push origin origin:refs/heads/new-feature
        git fetch origin
        git checkout --track -b new-feature origin/new-feature
        git pull
        git rebase master

5. Hack, commit and push your feature

        git add .
        git commit -m "Commit message"
        git push
    
    If the commit fails due to failing tests but you need to commit your changes nevertheless, use the `--no-verify` switch.
    
        git commit -m "Commit message" --no-verify
        git push

6. Pull and rebase the upstream repository

        git checkout master
        git pull avoinministerio master
        git push
        git checkout new-feature
        git rebase master
        # fix possible conflicts
        git push
        
  Sometimes git says this when you try to push the rebased branch:

  > "To prevent you from losing history, non-fast-forward updates were rejected
  Merge the remote changes (e.g. 'git pull') before pushing again.  See the
  'Note about fast-forwards' section of 'git push --help' for details."

  In that case, you need to run

        git pull --rebase
        git push
        
  If you're lazy, you can configure git so that it always uses the --rebase switch when you run git pull.

        git config pull.rebase true

7. Run tests to confirm your tests work with rebased master

        bundle install
        bundle exec rake db:migrate db:test:prepare
        bundle exec rake spec

8. Create a pull request in Github

        https://github.com/<username>/avoinministerio/pull/new/new-feature

## Pull request process

1. Add new developer's repository to remote if needed

        git remote add kalleya git@github.com:kalleya/avoinministerio.git

2. Bring his repository into yours. Please notice the output of the command, it says which branches the fetch brought.

        git fetch kalleya

3.  Check the branch if needed with

        git branch -a   # lists all local and remote branches
        # pick one remote branch that you'll test for merging

        # checkout remote branch as a local branch
        git checkout -b ui-fixes-incl-drafts kalleya/ui-fixes-incl-drafts

4. Setup for testing

        bundle install
        bundle exec rake db:migrate db:test:prepare

        # if db:migrate also emptied your db you probably need to seed some data
        bundle exec rake db:seed

        bundle exec rake spec
        rails s

        # if everything works then you're ready for final step, jump to 6

5. If things fail, hack around, make needed commits, and push to avoinministerio/master

6. Merge either way:
6.1 If automerge is possible and no local commits were needed, Open github pull request, and click Merge pull request button,
6.2 Manual merging:

        # merge to local master
        git checkout master
        git pull --rebase avoinministerio master
        # resolve possible conflicts
        git merge <feature-branch>          # please notice this branch is now local, ie. not kalleay/feature-branch anymore
        # resolve possible conflicts again
        # finally
        git push   # if cannot due non-fastforward, first git pull
        git push avoinministerio master

7. Deploy as needed, probably to staging for wider audience testing



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

The site can be protected with Basic Authentication by adding variables `AM_AUTH_USERNAME` and `AM_AUTH_PASSWORD` to Heroku.




## Dependencies

**JS Libraries**

* jQuery
* Raphael (http://raphaeljs.com/)
* gRaphael (http://g.raphaeljs.com/)

**Other**

* Ruby 1.9.X

## Tests

Run the tests using the following command(s):

`rspec spec` or `bundle exec rspec spec` or `bundle exec guard`

## Code Repository

[Git repository](https://github.com/avoinministerio/avoinministerio)

Everything is currently in the master branch. When building bigger features, use feature branches. When the feature is ready, delete the feature branch.
