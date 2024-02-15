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
    "id": "da5f475d-c0b4-499e-8b75-14fd447df007",
    "start_address_id": "23ecb6ef-ec09-4469-97b8-feec0c930f88",
    "destination_address_id": "2cd75452-a2e2-466f-92c0-8a1e49711fab",
    "created_at": "2024-02-15T17:57:19.700Z",
    "updated_at": "2024-02-15T17:57:19.700Z",
    "home_address": {
      "id": "2cd75452-a2e2-466f-92c0-8a1e49711fab",
      "address": "1600 Pennsylvania Ave",
      "created_at": "2024-02-15T17:57:19.620Z",
      "updated_at": "2024-02-15T17:57:19.620Z"
    },
    "start_address": {
      "id": "23ecb6ef-ec09-4469-97b8-feec0c930f88",
      "address": "1600 Amphitheatre Pkwy",
      "created_at": "2024-02-15T17:57:19.625Z",
      "updated_at": "2024-02-15T17:57:19.625Z"
    },
    "commute_distance": 2843.7222712416274,
    "commute_duration": 2512.233333333333,
    "destination_address": {
      "id": "2cd75452-a2e2-466f-92c0-8a1e49711fab",
      "address": "1600 Pennsylvania Ave",
      "created_at": "2024-02-15T17:57:19.620Z",
      "updated_at": "2024-02-15T17:57:19.620Z"
    },
    "ride_distance": 2849.750208159867,
    "ride_duration": 2509.9666666666667,
    "ride_earnings": 6025.601978906467,
    "score": 1.199793313469489
  },
  {
    "id": "68e339e4-ed2a-4cf5-bb4a-406b901a0d15",
    "start_address_id": "23ecb6ef-ec09-4469-97b8-feec0c930f88",
    "destination_address_id": "66f153e4-a8cb-4494-b0ae-a1e2907eb177",
    "created_at": "2024-02-15T17:57:19.664Z",
    "updated_at": "2024-02-15T17:57:19.664Z",
    "home_address": {
      "id": "2cd75452-a2e2-466f-92c0-8a1e49711fab",
      "address": "1600 Pennsylvania Ave",
      "created_at": "2024-02-15T17:57:19.620Z",
      "updated_at": "2024-02-15T17:57:19.620Z"
    },
    "start_address": {
      "id": "23ecb6ef-ec09-4469-97b8-feec0c930f88",
      "address": "1600 Amphitheatre Pkwy",
      "created_at": "2024-02-15T17:57:19.625Z",
      "updated_at": "2024-02-15T17:57:19.625Z"
    },
    "commute_distance": 2843.7222712416274,
    "commute_duration": 2512.233333333333,
    "destination_address": {
      "id": "66f153e4-a8cb-4494-b0ae-a1e2907eb177",
      "address": "1588 E Thomspon Blvd",
      "created_at": "2024-02-15T17:57:19.614Z",
      "updated_at": "2024-02-15T17:57:19.614Z"
    },
    "ride_distance": 319.3271776007556,
    "ride_duration": 299.06666666666666,
    "ride_earnings": 682.3374330678,
    "score": 0.24271242239099353
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
