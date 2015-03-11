
# safaci2000 Notes
The original author of this script removed the project.  Or at least I can't find it anymore.  I pushed this back on github if anyone finds this useful.  Last update I believe broke the login mechanism.

If you port this to python, I'll buy you a beer assuming you can get it to work properly.


----
# I needed a way to download the Patreon user data.

So I created a web crawler task to do so. The task uses my environment variables (PATREON_EMAIL, and PATREON_PASSWORD) to authenticate, fetch the CSV, filter it, and return it as a proper Ruby hash.

This is a substitute for using a proper API, which I'm under the impression Patreon might themselves eventually release.

## Instructions

First..
Add Mechanize to your Gemfile, and make sure to install it with `bundle install`.

Next, set your environment variables.

```bash
export PATREON_EMAIL="my@email.com"
export PATREON_PASSWORD="mypassword"
```

Finally, create a task (or something) to use the scraper. Here's an example:

```ruby
require "#{Rails.root}/lib/scraper.rb"

namespace :mywebsite do
  task :process_patreon_users do
    agent = Mechanize.new
    Scraper::Patreon::authenticate(agent)

    patreon = Scraper::Patreon::fetch_user_hash_from_csv(agent)
    puts patreon[:name].inspect # A beautiful array of your patreon pledger's names.
    # Also try: patreon[:email], patreon[:pledge], patreon[:lifetime], patreon[:status], patreon[:twitter]
    #      .... and patreon[:shipping], patreon[:start], patreon[:MaxAmount]
  end
end
```
