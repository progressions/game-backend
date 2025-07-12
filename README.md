Game Backend API
A Rails API for a simple exploration game where players navigate themed rooms. Built with Rails 8.0, PostgreSQL, and UUIDs, it uses JWT for authentication and supports dynamic room generation (planned for Grok API integration).
Features

User authentication via email/password with JWT.
Games scoped to users, with themes (fantasy, action, adventure).
Rooms with connections for navigation, tracked by player history.
API endpoints for managing games, rooms, players, and themes.

Prerequisites

Ruby 3.2.2 or later
Rails 8.0
PostgreSQL 13 or later
Node.js (for future frontend integration, optional)
curl or Postman for testing

Setup Instructions
1. Clone the Repository
git clone <repository-url>
cd game-backend

2. Install Dependencies
Install Ruby gems:
bundle install

3. Configure PostgreSQL
Ensure PostgreSQL is running. Create a user with database creation privileges:
psql -U postgres
CREATE ROLE game_user WITH LOGIN PASSWORD 'your_password';
ALTER ROLE game_user CREATEDB;
\q

Update config/database.yml with your PostgreSQL credentials:
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  host: localhost
  username: game_user
  password: your_password

development:
  <<: *default
  database: game_backend_development

test:
  <<: *default
  database: game_backend_test

production:
  <<: *default
  database: game_backend_production
  username: <%= ENV["DB_USERNAME"] %>
  password: <%= ENV["DB_PASSWORD"] %>

Create databases:
rails db:create

4. Run Migrations
Apply database migrations:
rails db:migrate

5. Seed the Database
Populate initial data (user, themes, game, rooms, connections):
rails db:seed

This creates:

User: email: test@example.com, password: password123
Themes: fantasy, action, adventure
A game for the user with the fantasy theme
Rooms: Twilight Hollow, Mossy Glade, Starlit Ruins
Connections between rooms (e.g., Mossy Trail, Rune Gate)

6. Run the Server
Start the Rails server:
rails server

The API will be available at http://localhost:3000.
7. Test Authentication
Login to get a JWT token:
curl -X POST http://localhost:3000/api/v1/login \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "password123"}'

Copy the token from the response:
{
  "user_id": "<uuid>",
  "token": "<jwt_token>",
  "message": "Logged in"
}

Test a protected endpoint (e.g., list games):
curl -X GET http://localhost:3000/api/v1/games \
  -H "Authorization: Bearer <jwt_token>"

8. Run Tests
Run RSpec tests to verify functionality:
bundle exec rspec

API Endpoints
See API.md for detailed endpoint documentation, including:

POST /api/v1/login: Authenticate user and get JWT.
GET /api/v1/games: List user’s games.
POST /api/v1/games: Create a new game.
GET /api/v1/rooms: List rooms in user’s games.
GET /api/v1/rooms/:id: Get a specific room.
POST /api/v1/players: Create a player.
GET /api/v1/players/:id: Get player details.
POST /api/v1/players/:id/move: Move player or look around.
GET /api/v1/themes: List all themes (public).

Next Steps

Integrate Grok API for dynamic room generation (see https://x.ai/api).
Set up a Next.js frontend to interact with the API.
Add more seed data or test cases as needed.
