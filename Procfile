web: bundle exec unicorn -p $PORT -e $RAILS_ENV -c ./config/unicorn.rb
worker:  bundle exec rake jobs:work