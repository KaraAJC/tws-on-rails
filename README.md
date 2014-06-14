# TWS

### Development

This is a simple Rails app with a Postgres database.

To get it set up locally, make sure you have Ruby and Postgres
installed, then:


```
git clone https://github.com/TeaWithStrangers/tws-on-rails.git tws
cd tws
bundle install

# create a `tws` role in postgres with the
# ability to create databases
createuser tws -d

# create the dev and test databases
rake db:create

# Load the schema
rake db:schema:load

# Start mailcatcher in the background
mailcatcher &

# Start the server
rails s

# For prodution
rake db:create_roles

# For Development
# Create some development data to play arond with
# This includes creating roles
# This will drop the database if it exists and create it again.
rake db:seed_dev
```
