# Viewing Party Solo - Base Repo

This is the base repo for the [Viewing Party Solo project](https://backend.turing.edu/module3/projects/viewing_party_solo) used for Turing's Backend Module 3.

### About this Project

Viewing Party Solo is an application that allows users to explore movies and create a Viewing Party Event that invites users and keeps track of a host. Mainly, your job is to connect with an external API and collect relevant information on each movie, its cast, and other information, to display it on each Viewing Party page. 

## Setup

1. Fork and Clone the repo
2. Install gem packages: `bundle install`
3. Setup the database: `rails db:{create,migrate,seed}`

Spend some time familiarizing yourself with the functionality and structure of the application so far. 

When you run `bundle exec rspec`, you should have 26 passing tests (both features & models combined). 

### Use the application
`rails s`, navigate to `127.0.0.0:3000` and click around the site. 


## Versions

- Ruby 3.2.2

- Rails 7.1.2

Example wireframes to follow are found [here](https://backend.turing.edu/module3/projects/viewing_party_solo/wireframes)


User Story 4 problem break down (Story Tasking)
- Visit new viewing party page and see movie title, field for duration of party, date for party, time for party, optional guest emails to add to party, create party button
  - Button should create viewing party and take user to '/users/:user_id/movies/:movie_id/viewing_party' index page and see the viewing party
  - The user who creates the party should be the host of the party and there should only be one host per party
  - Other users should be able to see the parties they've been invited to on their party index page
  - Party cant be shorter than the movies duration

- Things that will be needed to complete this:
  - Viewing party controller with new, create, and index action
  - Views for new and index actions
  x- Update table for viewing parties to include movie_id column to keep track of movie associated with party
  - Create action built to build new viewing party record in local db
  - Custom validation in order to make sure viewing party cant be created with duration shorter than movie runtime
  - Testing for all the above outside of feature test currently built
    - sad path testing for all required fields in viewing party new form