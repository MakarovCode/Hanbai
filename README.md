# Hanbai
Change

# DEMO
[Hanbai](https://hanbai.geekoi.com) - Test the web app


# TECHNOLOGIES USED AND CHALLENGES
* NodeJS
    * The current version use the last version of node and socket.io in order to allow teams to work together on the same funnel.
    * [NodeJS Instalation Guide](https://nodejs.dev/learn/how-to-install-nodejs/) - For real-time functionalities
* Ruby;
    * Version 2.7.1;
* Rails;
    * Version 6.1;
* AngularJS;
    * Legacy;
    * This app has a Trello like interface for dealing with the Funnels and Sales
* PostgreSQL;
    * 13;


# HOW TO INSTALL

```ruby
# 1. Clone the repo

git clone https://github.com/MakarovCode/Hanbai.git

# 2. Run bundle

bundle

# 3. Run the DB

rails db:create db:migrate db:seed

# 4. Make sure to install the unaccent function in PostgreSQL

psql YourDataBaseName

# SQL
CREATE EXTENSION unaccent;

# Type localhost:3000

# DO NOT FORGET TO install node in order to test real time functionalities
```

# DISCLAIMER
I DO NOT give support to this project any more, you are free to use the code in anyway you want, is free to use, but this web application as it is may present Bugs and Errors.

I developed this project several years ago, I kept a DEMO but is not getting supported, some libraries and dependencies maybe deprecated, the only technologies I updated were Ruby, Rails and PostgreSQL.
