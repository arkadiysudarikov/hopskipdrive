# HopSkipDrive Drivers API


<img width="257" alt="HopSkipDrive" src="https://github.com/arkadiysudarikov/hopskipdrive/assets/382532/8f0304d0-23cc-4aea-b3d4-1da00d5e9ebd">

HopSkipDrive API for drivers. 

## Description

```
Unlike many other rideshares, HopSkipDrive is a scheduled ride service and not an on-demand ride service.
In our app for drivers, we show them a list of upcoming rides and they can pick the ones they want.
Our goal is to show them the best rides for each driver first, so to that end we have an internal scoring system.
In this exercise you will be implementing a slimmed down version of it
```

## Definitions

The **driving distance** between two addresses is the distance in miles that it would take to drive a reasonably
efficient route between them. It is not the straight line distance. It can be calculated by using a routing service

The **driving duration** between two addresses is the amount of time in hours it would take to drive the driving distance under realistic driving conditions. It can be calculated by using a routing service

The **commute distance** for a ride is the driving distance from the driver’s home address to the start of the ride, in miles

The **commute duration** for a ride is the amount of time it is expected to take to drive the commute distance, in hours.

The **ride distance** for a ride is the driving distance from the start address of the ride to the destination address, in miles

The **ride duration** for a ride is the amount of time it is expected to take to drive the ride distance, in hours

The **ride earnings** is how much the driver earns by driving the ride. It takes into account both the amount of time the ride is expected to take and the distance. 

For the purposes of this exercise, it is calculated as: $12 + $1.50 per mile beyond 5 miles + (**ride duration**) * $0.70 per minute beyond 15 minutes

## Prompt 

```
The primary goal of this exercise is for you to demonstrate how you think about testing,
readability, and structuring a Rails application. We are also evaluating your ability to
understand and implement requirements.
```

## Specification

 - [x] Create a Rails 7 application, using Ruby 3+

 - [x] Include the following entities:

   - [x] Ride
     - [x] Has an id, a start address and a destination address. You may end up adding additional information
   - [x] Driver
     - [x] Has an id and a home address

 - [x] Build a RESTful API endpoint that returns a paginated JSON list of rides in descending score order for a given driver

 - [x] Please write up API documentation for this endpoint in MarkDown or alternative

 - [x] Calculate the score of a ride in $ per hour as: (**ride earnings**) / (**commute duration** + **ride duration**). Higher is better

 - [x] Google Maps is expensive. Consider how you can reduce duplicate API calls

 - [x] Include RSpec tests

## Features

- Implements the upcoming rides endpoint to be used by the driver's app. 

## Design Decisions

For this project I ended up making some design decisions to keep the project on track while developing the application: 

 * I decided to use UUID for all IDs to increase information security. 

 * Address table holds addresses for drivers and rides
    * Address is a string that is valid for Google Directions API 
        * Location ID should be used in production to accurately query the same locations
          * Google Place ID is an example of an ID that can be used to identify addresses

   Similar addresses that share a location ID (potentially stored in a long-lived, distributed Solid Cache) can be used by both Driver and Ride and used in the API call to get commute and ride distance and duration. 

* I use the Rails Credentials to keep the Google Directions API Key secure in both development and production. 

* Because I'm working with two entities, Driver and Ride, I decided to use a module for the methods. 

* I decided to create a client class to call the Google Directions API. 


* I decided to use RSwag to provide OpenAPI UI compliance for the endpoint.

* I use Pagy gem for pagination.
  * It handles pagination via the query parameter and headers.
    * I set the default to be 5 items per page. 

* I decided to cache the data returned for 5 minutes at a time. 
  * I think the new Solid Cache can a great candidate for storing data returned from the Google API. 
    * I think cache can be kept warm between the server restarts to continue to provide fast response from the server. 

* I considered adding the "pickup time" to the upcoming rides but for demo purposes I decided to leave it out so that rides can be retrieved at any time in the future. 

## Assumptions 

I tried to make few assumptions but here they are: 

  * Ride start and destination addresses cannot be the same. 

## Gems for calling APIs

Libraries provide benefits such as retries, improved error-handling and backoff and should be used in production environments. 

I considered using various libraries but ultimately decided to make a simple call instead for this project. 

## Technologies Used

- Ruby on Rails
- PostgreSQL
- OpenAPI

## Installation

1. Clone the repository: `git clone https://github.com/arkadiysudarikov/hopskipdrive.git`
2. Install dependencies: `bundle install`
3. Set up the database: `rails db:setup`
4. Run Rails Credentials to add `google_api_key`: `rails credentials:edit`
5. Run RSpec: `rspec`
6. Start the server: `rails server`

## Documentation

[Code coverage](https://hopskipdrive-fa2a8e6ce701.herokuapp.com/coverage/#_AllFiles)

[UpcomingRides](https://hopskipdrive-fa2a8e6ce701.herokuapp.com/doc/UpcomingRides.html) (RDoc)

[GoogleDirectionsApiClient](https://hopskipdrive-fa2a8e6ce701.herokuapp.com/doc/GoogleDirectionsApiClient.html) (RDoc)

## APU Usage

Please refer to the project's [OpenAPI specification](https://hopskipdrive-fa2a8e6ce701.herokuapp.com/api-docs/index.html) for the project. 

  * I seed the database with a Driver ID `e76885d9-dc50-4616-830e-cd24beefd7d9` that can be used to try out the endpoint.

## API Endpoints

I offer both `/api/v1/drivers/{driver_id}/upcoming_rides` and `/api/v1/{driver_id}/upcoming_rides` endpoints. 

```json
[
  {
    "id": "f6420103-f79e-4b8e-9cd7-c6f0f523948c",
    "start_address_id": "9b6e17ca-9543-452e-98cd-9423c2c36923",
    "destination_address_id": "943d2863-d62d-4426-9b62-c8c697fc97e3",
    "created_at": "2024-02-16T04:33:32.839Z",
    "updated_at": "2024-02-16T04:33:32.839Z",
    "home_address": {
      "id": "943d2863-d62d-4426-9b62-c8c697fc97e3",
      "address": "1600 Amphitheatre Pkwy",
      "created_at": "2024-02-16T04:33:32.790Z",
      "updated_at": "2024-02-16T04:33:32.790Z"
    },
    "start_address": {
      "id": "9b6e17ca-9543-452e-98cd-9423c2c36923",
      "address": "1588 E Thomspon Blvd",
      "created_at": "2024-02-16T04:33:32.781Z",
      "updated_at": "2024-02-16T04:33:32.781Z"
    },
    "commute_distance": 319.3271776007556,
    "commute_duration": 4.984444444444445,
    "destination_address": {
      "id": "943d2863-d62d-4426-9b62-c8c697fc97e3",
      "address": "1600 Amphitheatre Pkwy",
      "created_at": "2024-02-16T04:33:32.790Z",
      "updated_at": "2024-02-16T04:33:32.790Z"
    },
    "ride_distance": 319.08670635167215,
    "ride_duration": 4.92,
    "ride_earnings": 483.13005952750825,
    "score": 48.77911752016575
  },
  {
    "id": "4d2a3d65-2477-4c42-904d-fea7c329250d",
    "start_address_id": "a1f1b68a-9010-4820-a3b5-c8e22c331ad0",
    "destination_address_id": "943d2863-d62d-4426-9b62-c8c697fc97e3",
    "created_at": "2024-02-16T04:33:32.853Z",
    "updated_at": "2024-02-16T04:33:32.853Z",
    "home_address": {
      "id": "943d2863-d62d-4426-9b62-c8c697fc97e3",
      "address": "1600 Amphitheatre Pkwy",
      "created_at": "2024-02-16T04:33:32.790Z",
      "updated_at": "2024-02-16T04:33:32.790Z"
    },
    "start_address": {
      "id": "a1f1b68a-9010-4820-a3b5-c8e22c331ad0",
      "address": "2112 E Thompson Blvd",
      "created_at": "2024-02-16T04:33:32.794Z",
      "updated_at": "2024-02-16T04:33:32.794Z"
    },
    "commute_distance": 319.79444989871627,
    "commute_duration": 4.999722222222222,
    "destination_address": {
      "id": "943d2863-d62d-4426-9b62-c8c697fc97e3",
      "address": "1600 Amphitheatre Pkwy",
      "created_at": "2024-02-16T04:33:32.790Z",
      "updated_at": "2024-02-16T04:33:32.790Z"
    },
    "ride_distance": 319.55397864963277,
    "ride_duration": 4.934722222222222,
    "ride_earnings": 483.83096797444915,
    "score": 48.70236787574144
  }
]
```

`ride_distance` is in miles.
`ride_duration` is in hours. 
`ride_earnings` is in USD. 
`score` is in USD/hour. 

## Screenshot

![Screenshot 2024-02-15 at 20 36 01 (2)](https://github.com/arkadiysudarikov/hopskipdrive/assets/382532/d4bc4daa-6f21-4ff9-b1c1-659a9060ca7c)


<img width="1680" alt="Screenshot 2024-02-15 at 20 24 48" src="https://github.com/arkadiysudarikov/hopskipdrive/assets/382532/492f1e95-c867-4dc1-a274-b1c6b5bd0884">



## Contributing

If you'd like to contribute to this project, please follow these steps:

1. Fork the repository
2. Create a new branch: `git checkout -b feature/your-feature`
3. Make your changes and commit them: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin feature/your-feature`
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

- Arkadiy Sudarikov - [arkadiy@arkadiy.com](mailto:arkadiy@arkadiy.com)
- Project Link: [https://github.com/arkadiysudarikov/hopskipdrive](https://github.com/arkadiysudarikov/hopskipdrive)
