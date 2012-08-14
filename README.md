# datainsight-ga-collector


Collect the statics specified by the configuration from google analytics

## Setup

The first thing that must be done when using this collector is to authorise the application with google. First you will need
 to [generate an authorisation code](https://accounts.google.com/o/oauth2/auth?response_type=code&scope=https://www.googleapis.com/auth/analytics.readonly&redirect_uri=urn:ietf:wg:oauth:2.0:oob&client_id=1054017153726.apps.googleusercontent.com).
This code then needs to be passed to the `bin/collector` command line script using `--authorisation_code=CODE`

## Message Format

    {
      "envelope":{
        "collected_at":"2012-08-13T18:09:20+01:00",
        "collector":"Google Analytics"
      },
      "payload":{
        "start_at":"2012-07-29T00:00:00+00:00",
        "end_at":"2012-08-05T00:00:00+00:00",
        "value":32199,
        "site":"govuk"
      }
    }

## Usage

This collector is run from the command line with the `bin/collector` script. This command requires an action which
can be either `help`, `print` or `broadcast`. It also requires a `--config` option which defines which configuration
 class is used. For example the following command will print messages to the terminal using the `WeeklyUniqueVisitors`
 configuration.

    $ bundle exec bin/collector --config=WeeklyUniqueVisitors print

### Other Options

`--days_ago`: This option allows you to collect all data since a given time ago. The frequency will depend on the
configuration you use.

`--authorisation_code`: Pass in the code to authorise this project with Google.
