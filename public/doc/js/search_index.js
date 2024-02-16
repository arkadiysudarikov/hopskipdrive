var search_data = {"index":{"searchIndex":["address","api","v1","upcomingridescontroller","applicationcontroller","applicationrecord","createaddresses","createdrivers","createrides","directionsapierror","driver","enableextensionforuuid","googledirectionsapiclient","hopskipdrive","application","object","pagy","ride","upcomingrides","activate_bundler()","activation_error_handling()","add_ride_attributes()","bundler_requirement()","bundler_requirement_for()","change()","change()","change()","change()","cli_arg_version()","env_var_version()","gemfile()","get_data()","get_directions()","get_directions()","index()","invoked_as_script?()","load_bundler!()","lockfile()","lockfile_version()","new()","ride_earnings()","score()","sort_upcoming_rides()","system!()","upcoming_rides()","gemfile","gemfile.lock","procfile","readme","rakefile","config.ru","credentials.yml.enc","master.key","development.log","test.log","robots","swagger.yaml","caching-dev","local_secret","server.pid","restart"],"longSearchIndex":["address","api","api::v1","api::v1::upcomingridescontroller","applicationcontroller","applicationrecord","createaddresses","createdrivers","createrides","directionsapierror","driver","enableextensionforuuid","googledirectionsapiclient","hopskipdrive","hopskipdrive::application","object","pagy","ride","upcomingrides","object#activate_bundler()","object#activation_error_handling()","upcomingrides#add_ride_attributes()","object#bundler_requirement()","object#bundler_requirement_for()","createaddresses#change()","createdrivers#change()","createrides#change()","enableextensionforuuid#change()","object#cli_arg_version()","object#env_var_version()","object#gemfile()","upcomingrides#get_data()","googledirectionsapiclient#get_directions()","upcomingrides#get_directions()","api::v1::upcomingridescontroller#index()","object#invoked_as_script?()","object#load_bundler!()","object#lockfile()","object#lockfile_version()","googledirectionsapiclient::new()","upcomingrides#ride_earnings()","upcomingrides#score()","upcomingrides#sort_upcoming_rides()","object#system!()","upcomingrides#upcoming_rides()","","","","","","","","","","","","","","","",""],"info":[["Address","","Address.html","","<p>Adress model is used to store valid formatted addresses.\n"],["Api","","Api.html","","<p>API module\n"],["Api::V1","","Api/V1.html","","<p>API::V1 module for version 1 of the API\n"],["Api::V1::UpcomingRidesController","","Api/V1/UpcomingRidesController.html","","<p>This controller is responsible for returning the upcoming rides for a driver\n"],["ApplicationController","","ApplicationController.html","","<p>Description: This is the base controller for the application. All other controllers will inherit from …\n"],["ApplicationRecord","","ApplicationRecord.html","","<p>Description: This file is used to define the ApplicationRecord class which is the parent class for all …\n"],["CreateAddresses","","CreateAddresses.html","",""],["CreateDrivers","","CreateDrivers.html","",""],["CreateRides","","CreateRides.html","",""],["DirectionsAPIError","","DirectionsAPIError.html","","<p>DirectionsAPIError is a custom error class that is raised when there is an error fetching directions …\n"],["Driver","","Driver.html","","<p>Driver model is used to store the driver’s address.\n"],["EnableExtensionForUuid","","EnableExtensionForUuid.html","",""],["GoogleDirectionsApiClient","","GoogleDirectionsApiClient.html","","<p>GoogleDirectionsApiClient is a service class that fetches directions from the Google Directions API\n"],["Hopskipdrive","","Hopskipdrive.html","",""],["Hopskipdrive::Application","","Hopskipdrive/Application.html","",""],["Object","","Object.html","",""],["Pagy","","Pagy.html","",""],["Ride","","Ride.html","","<p>A ride has a start address and a destination address. The destination address must be different from …\n"],["UpcomingRides","","UpcomingRides.html","","<p>Description: This module is used to get the upcoming rides from the database.\n"],["activate_bundler","Object","Object.html#method-i-activate_bundler","()",""],["activation_error_handling","Object","Object.html#method-i-activation_error_handling","()",""],["add_ride_attributes","UpcomingRides","UpcomingRides.html#method-i-add_ride_attributes","(driver, ride)","<p>The add_ride_attributes method takes in a driver and a ride and returns a new hash with the ride’s …\n"],["bundler_requirement","Object","Object.html#method-i-bundler_requirement","()",""],["bundler_requirement_for","Object","Object.html#method-i-bundler_requirement_for","(version)",""],["change","CreateAddresses","CreateAddresses.html#method-i-change","()",""],["change","CreateDrivers","CreateDrivers.html#method-i-change","()",""],["change","CreateRides","CreateRides.html#method-i-change","()",""],["change","EnableExtensionForUuid","EnableExtensionForUuid.html#method-i-change","()",""],["cli_arg_version","Object","Object.html#method-i-cli_arg_version","()",""],["env_var_version","Object","Object.html#method-i-env_var_version","()",""],["gemfile","Object","Object.html#method-i-gemfile","()",""],["get_data","UpcomingRides","UpcomingRides.html#method-i-get_data","(home_address, start_address, destination_address)","<p>The get_data method takes in the driver’s home address, the start address, and the destination address, …\n"],["get_directions","GoogleDirectionsApiClient","GoogleDirectionsApiClient.html#method-i-get_directions","(origin, destination)","<p>get_directions fetches directions from the Google Directions API\n"],["get_directions","UpcomingRides","UpcomingRides.html#method-i-get_directions","(origin, destination)","<p>The get_directions method takes in the start and destination addresses and returns the commute distance …\n"],["index","Api::V1::UpcomingRidesController","Api/V1/UpcomingRidesController.html#method-i-index","()",""],["invoked_as_script?","Object","Object.html#method-i-invoked_as_script-3F","()",""],["load_bundler!","Object","Object.html#method-i-load_bundler-21","()",""],["lockfile","Object","Object.html#method-i-lockfile","()",""],["lockfile_version","Object","Object.html#method-i-lockfile_version","()",""],["new","GoogleDirectionsApiClient","GoogleDirectionsApiClient.html#method-c-new","(api_key)","<p>api_key is the Google Directions API key\n"],["ride_earnings","UpcomingRides","UpcomingRides.html#method-i-ride_earnings","(ride_distance, ride_duration)",""],["score","UpcomingRides","UpcomingRides.html#method-i-score","(ride_earnings, commute_duration, ride_duration)","<p>The score is a metric that takes into account the ride earnings, the commute duration, and the ride duration. …\n"],["sort_upcoming_rides","UpcomingRides","UpcomingRides.html#method-i-sort_upcoming_rides","(upcoming_rides)","<p>The sort_upcoming_rides method takes in the upcoming rides and returns the upcoming rides sorted by the …\n"],["system!","Object","Object.html#method-i-system-21","(*args)",""],["upcoming_rides","UpcomingRides","UpcomingRides.html#method-i-upcoming_rides","(driver, rides)","<p>The upcoming_rides method takes in a driver and returns the upcoming rides from the database. It uses …\n"],["Gemfile","","Gemfile.html","","<p>source “rubygems.org”\n<p>ruby “3.2.3”\n<p># Bundle edge Rails instead: gem “rails”, …\n"],["Gemfile.lock","","Gemfile_lock.html","","<p>GEM\n\n<pre>remote: https://rubygems.org/\nspecs:\n  actioncable (7.1.3)\n    actionpack (= 7.1.3)\n    activesupport ...</pre>\n"],["Procfile","","Procfile.html","","<p>web: bundle exec puma -C config/puma.rb\n"],["README","","README_md.html","","<p>HopSkipDrive Drivers API\n<p>&lt;img width=“257” alt=“HopSkipDrive” src=“github.com/arkadiysudarikov/hopskipdrive/assets/382532/8f0304d0-23cc-4aea-b3d4-1da00d5e9ebd …\n"],["Rakefile","","Rakefile.html","","<p># Add your own tasks in files placed in lib/tasks ending in .rake, # for example lib/tasks/capistrano.rake …\n"],["config.ru","","config_ru.html","","<p># This file is used by Rack-based servers to start the application.\n<p>require_relative “config/environment” …\n"],["credentials.yml.enc","","config/credentials_yml_enc.html","","<p>cRatpdlTL70gnagFLDGQmnnS2kozncaO2JD3uoyjyMLL6fg/06+2YLwM2sNc1r2RXJcwhBLgGGPZY01/mM2pS1Us+eQiDt0wJac3ft8RUlsLrAicIY4bSvaoxV8HOemueWjZXeyORr/R3Dg1xAShFxKRELSskCSmXaguqgT53+sV5OntzxCxnc7+SH7aG0xeEDh+mSweFtkYTl5g8R1/PUZ6M5Zdk0r6tygpqcvR/p2bfSD0eq1tDticRmW1dj2MiZoXQyK6I/XsLvs6KDOYwxgR4hahz+Kigtq92Xe8GdK7MLexAgZBe6/iRaIumNAh48pEApED+0w0PsMj2GEVRGrQRxQu+JEJLjtX/VeK9UrefC/JzI2XcQj26YEf5r3kem8K2QtStYWPuUsn2jJGWLr6hmw=–5Xq8ibU5f5yrpF4g–u3HN9XYheU89XEMAZfm5RQ== …\n"],["master.key","","config/master_key.html","","<p>0053a965ce1f3921018a4784d4b1b2ee\n"],["development.log","","log/development_log.html","","\n<pre>\u001b[1m\u001b[35m (0.3ms)\u001b[0m  \u001b[1m\u001b[35mDROP DATABASE IF EXISTS &quot;hopskipdrive_development&quot;\u001b[0m\n\u001b[1m\u001b[35m (0.1ms)\u001b[0m ...</pre>\n"],["test.log","","log/test_log.html","","\n<pre>\u001b[1m\u001b[35m (51.2ms)\u001b[0m  \u001b[1m\u001b[35mDROP DATABASE IF EXISTS &quot;hopskipdrive_test&quot;\u001b[0m\n\u001b[1m\u001b[35m (109.1ms)\u001b[0m ...</pre>\n"],["robots","","public/robots_txt.html","","<p># See www.robotstxt.org/robotstxt.html for documentation on how to use the robots.txt file\n"],["swagger.yaml","","swagger/v1/swagger_yaml.html","","<p>openapi: 3.0.1 info:\n\n<pre>title: API V1\nversion: v1</pre>\n<p>paths:\n"],["caching-dev","","tmp/caching-dev_txt.html","",""],["local_secret","","tmp/local_secret_txt.html","","<p>ed1be08d0a757a9c8120d7f88dd1f399e75feaa0e50be60d62b7ffef9ef9355bfde827f69071d80953dcc59c9ed12aea86a7b74ca1b45fb6441c42cfb8a8f7ef …\n"],["server.pid","","tmp/pids/server_pid.html","","<p>17689\n"],["restart","","tmp/restart_txt.html","",""]]}}