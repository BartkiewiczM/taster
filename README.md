# Taster API

An API‑only Ruby on Rails backend that suggests random meals, remembers what you cook, and continuously refines your personal **taste profile** with the help of OpenAI.
It powers the Taster React client and is deployed on **[Railway](https://railway.app)** with managed **PostgreSQL**, **Redis**, and **Sidekiq** workers.

---

\## Table of Contents

1. [Features](#features)
2. [Tech Stack](#tech-stack)
3. [Data Model](#data-model)
4. [Background Jobs](#background-jobs)
5. [API Reference](#api-reference)
6. [Deployment on Railway](#deployment-on-railway)

---

\## Features

* **User authentication** via Devise + JWT
* **Random meal discovery** from [TheMealDB.com](https://themealdb.com).
* **Meal history** (last 10 meals per user) with favourites ★ and 1‑5 ⭐ ratings.
* **AI‑powered taste profile**: every time your preferences change, a Sidekiq job recalculates your profile using OpenAI and caches the result.
* **OpenAPI 3 spec** (see [`docs/openapi.yml`](docs/openapi.yml)) for easy SDK generation.

\## Tech Stack

| Layer           | Technology                                                              |
| --------------- | ----------------------------------------------------------------------- |
| Language        | Ruby 3.3                                                                |
| Framework       | Rails 7.1 (API‑only)                                                    |
| Database        | PostgreSQL                                                              |
| Cache / Queue   | Redis                                                                   |
| Background Jobs | Sidekiq                                                                 |
| Auth            | Devise, `warden-jwt_auth`                                               |
| External API    | TheMealDB, OpenAI                                                       |
| Deployment      | Railway (services: `web`, `sidekiq`, `postgres`, `redis`)               |

\## Data Model

| Model           | Key Columns                                                    | Associations                          |
| --------------- | -------------------------------------------------------------- | ------------------------------------- |
| **User**        | `email`, `encrypted_password`, `preferences` (JSON)            | has\_many `meals` (through histories) |
| **Meal**        | `name`, `category`, `ingredients`, `recipe`, `external_api_id` | has\_many `meal_histories`            |
| **MealHistory** | `favourite` (bool), `rating` (int)                             | belongs\_to `user`, `meal`            |

*(See [`db/schema.rb`](db/schema.rb) for the authoritative schema.)*

\## Tests

```bash
bundle exec rspec
```

\## Background Jobs

| Job                              | Schedule                    | Purpose                                                       |
| -------------------------------- | --------------------------- | ------------------------------------------------------------- |
| `ScheduleTasteProfileUpdatesJob` | every 5min                  | Enqueue `UpdateTasteProfileJob` for every user                |
| `UpdateTasteProfileJob`          | async                       | Rebuild user taste profile if the preference checksum changed |

Queues are configured in [`config/sidekiq.yml`](config/sidekiq.yml)

\## API Reference
Full schema is available in [`docs/openapi.yml`](docs/openapi.yml).
Below is a quick cheat‑sheet of the main endpoints:

| Method & Path                                   | Description                                  |
| ----------------------------------------------- | -------------------------------------------- |
| **POST** `/api/v1/signup`                       | Register a new user                          |
| **POST** `/api/v1/login`                        | Retrieve JWT token                           |
| **DELETE** `/api/v1/logout`                     | Invalidate token                             |
| **GET** `/api/v1/meals/random?category=Seafood` | Fetch a random meal (optionally filtered)    |
| **GET** `/api/v1/meals/:id`                     | Get one of your saved meals                  |
| **PATCH** `/api/v1/meal_histories/:id`          | Update `favourite` ★ or `rating` ⭐          |
| **GET** `/api/v1/users/preferences`             | Return AI‑generated taste profile            |

Requests must include an `Authorization: Bearer <JWT>` header unless noted otherwise.

\## Deployment on Railway
This repo expects **four Railway services** in the same project:

| Service    | Type      |
| ---------- | --------- |
| `web`      | Rails app |
| `sidekiq`  | Worker    |
| `postgres` | Add‑on    |
| `redis`    | Add‑on    |

Environment variables are synced across services via Railway’s **Variables** tab.