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

## Features

- Implements the upcoming rides endpoint to be used by the driver's app. 

## Technologies Used

- Ruby on Rails
- PostgreSQL
- OpenAPI

## Installation

1. Clone the repository: `git clone https://github.com/arkadiysudarikov/hopskipdrive.git`
2. Install dependencies: `bundle install`
3. Set up the database: `rails db:setup`
4. Start the server: `rails server`

## Usage

Please refer to the project's [OpenAPI specicificaiton. 
](https://hopskipdrive-fa2a8e6ce701.herokuapp.com/api-docs/index.html). 

## API Endpoints

`/api/v1/drivers/{driver_id}/upcoming_rides`

`/api/v1/{driver_id}/upcoming_rides`


```json

[
  {
    "id": "e5fa67c2-3224-4489-9999-77c90f2c2c27",
    "start_address_id": "222cf8ec-d1c2-4fca-ab91-4397b6261a10",
    "destination_address_id": "57adb1cf-e028-4c37-bb38-ece39ca365d5",
    "created_at": "2024-02-15T02:38:41.634Z",
    "updated_at": "2024-02-15T02:38:41.634Z",
    "home_address": {
      "id": "57adb1cf-e028-4c37-bb38-ece39ca365d5",
      "address": "1600 Pennsylvania Ave",
      "created_at": "2024-02-15T02:38:41.562Z",
      "updated_at": "2024-02-15T02:38:41.562Z"
    },
    "start_address": {
      "id": "222cf8ec-d1c2-4fca-ab91-4397b6261a10",
      "address": "2112 E Thompson Blvd",
      "created_at": "2024-02-15T02:38:41.572Z",
      "updated_at": "2024-02-15T02:38:41.572Z"
    },
    "commute_distance": 2728.2886152087194,
    "commute_duration": 2370.616666666667,
    "destination_address": {
      "id": "57adb1cf-e028-4c37-bb38-ece39ca365d5",
      "address": "1600 Pennsylvania Ave",
      "created_at": "2024-02-15T02:38:41.562Z",
      "updated_at": "2024-02-15T02:38:41.562Z"
    },
    "ride_distance": 2727.2981470664995,
    "ride_duration": 2373.866666666667,
    "ride_earnings": 5746.653887266416,
    "score": 1.2112285961449436
  },
  {
    "id": "70e03e90-7938-4981-b5d4-afdfe829867c",
    "start_address_id": "de873985-bf19-46c2-a42c-9e321519b3a4",
    "destination_address_id": "222cf8ec-d1c2-4fca-ab91-4397b6261a10",
    "created_at": "2024-02-15T02:38:41.629Z",
    "updated_at": "2024-02-15T02:38:41.629Z",
    "home_address": {
      "id": "57adb1cf-e028-4c37-bb38-ece39ca365d5",
      "address": "1600 Pennsylvania Ave",
      "created_at": "2024-02-15T02:38:41.562Z",
      "updated_at": "2024-02-15T02:38:41.562Z"
    },
    "start_address": {
      "id": "de873985-bf19-46c2-a42c-9e321519b3a4",
      "address": "1600 Amphitheatre Pkwy",
      "created_at": "2024-02-15T02:38:41.567Z",
      "updated_at": "2024-02-15T02:38:41.567Z"
    },
    "commute_distance": 2843.7222712416274,
    "commute_duration": 2512.233333333333,
    "destination_address": {
      "id": "222cf8ec-d1c2-4fca-ab91-4397b6261a10",
      "address": "2112 E Thompson Blvd",
      "created_at": "2024-02-15T02:38:41.572Z",
      "updated_at": "2024-02-15T02:38:41.572Z"
    },
    "ride_distance": 319.79444989871627,
    "ride_duration": 299.98333333333335,
    "ride_earnings": 683.6800081814077,
    "score": 0.24311071628480777
  }
]

```

## Screenshot

![Screenshot 2024-02-15 at 09 35 33 (2)](https://github.com/arkadiysudarikov/hopskipdrive/assets/382532/875ea5a6-ee02-4349-837f-9329af08422d)

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

- Your Name - [arkadiy@arkadiy.com](mailto:arkadiy@arkadiy.com)
- Project Link: [https://github.com/arkadiysudarikov/hopskipdrive](https://github.com/arkadiysudarikov/hopskipdrive)
