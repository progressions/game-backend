Game Backend API Documentation
This document describes the API endpoints for the "game-backend" Rails API, which powers a simple exploration game where players navigate rooms in a themed world. All endpoints are under the /api/v1 namespace and use JSON. Protected endpoints require a JWT token in the Authorization: Bearer <token> header, obtained via POST /api/v1/login.
Authentication
POST /api/v1/login
Authenticates a user and returns a JWT token.

Method: POST
Endpoint: /api/v1/login
Payload:{
  "email": "string",
  "password": "string"
}


Expected Response (200 OK):{
  "user_id": "<uuid>",
  "token": "<jwt_token>",
  "message": "Logged in"
}


Error Response (401 Unauthorized):{
  "errors": ["Invalid email or password"]
}



DELETE /api/v1/logout
Confirms logout (client discards JWT).

Method: DELETE
Endpoint: /api/v1/logout
Payload: None
Expected Response (200 OK):{
  "message": "Logged out"
}



Games
GET /api/v1/games
Lists all games for the authenticated user.

Method: GET
Endpoint: /api/v1/games
Headers: Authorization: Bearer <token>
Payload: None
Expected Response (200 OK):[
  {
    "id": "<uuid>",
    "user_id": "<uuid>",
    "theme_id": "<uuid>",
    "created_at": "2025-07-12T10:29:00Z",
    "updated_at": "2025-07-12T10:29:00Z",
    "theme": {
      "id": "<uuid>",
      "name": "fantasy",
      "description": "A world of magic."
    }
  }
]


Error Response (401 Unauthorized):{
  "errors": ["Unauthorized"]
}



POST /api/v1/games
Creates a new game for the authenticated user.

Method: POST
Endpoint: /api/v1/games
Headers: Authorization: Bearer <token>
Payload:{
  "game": {
    "theme_id": "<uuid>"
  }
}


Expected Response (201 Created):{
  "id": "<uuid>",
  "user_id": "<uuid>",
  "theme_id": "<uuid>",
  "created_at": "2025-07-12T10:29:00Z",
  "updated_at": "2025-07-12T10:29:00Z"
}


Error Response (422 Unprocessable Entity):{
  "errors": ["Theme must exist"]
}



GET /api/v1/games/:id
Fetches a specific game for the authenticated user.

Method: GET
Endpoint: /api/v1/games/:id
Headers: Authorization: Bearer <token>
Payload: None
Expected Response (200 OK):{
  "id": "<uuid>",
  "user_id": "<uuid>",
  "theme_id": "<uuid>",
  "created_at": "2025-07-12T10:29:00Z",
  "updated_at": "2025-07-12T10:29:00Z",
  "theme": {
    "id": "<uuid>",
    "name": "fantasy",
    "description": "A world of magic."
  }
}


Error Response (404 Not Found):{
  "errors": ["Game not found"]
}



Rooms
GET /api/v1/rooms
Lists all rooms for the authenticated user’s games.

Method: GET
Endpoint: /api/v1/rooms
Headers: Authorization: Bearer <token>
Payload: None
Expected Response (200 OK):[
  {
    "id": "<uuid>",
    "title": "Twilight Hollow",
    "description": "A stone chamber glowing faintly under moonlight.",
    "game_id": "<uuid>",
    "created_at": "2025-07-12T10:29:00Z",
    "updated_at": "2025-07-12T10:29:00Z",
    "connections": [
      {
        "id": "<uuid>",
        "label": "Mossy Trail",
        "description": "A winding path of soft moss.",
        "to_room_id": "<uuid>"
      }
    ]
  }
]


Error Response (401 Unauthorized):{
  "errors": ["Unauthorized"]
}



GET /api/v1/rooms/:id
Fetches a specific room for the authenticated user’s games.

Method: GET
Endpoint: /api/v1/rooms/:id
Headers: Authorization: Bearer <token>
Payload: None
Expected Response (200 OK):{
  "id": "<uuid>",
  "title": "Twilight Hollow",
  "description": "A stone chamber glowing faintly under moonlight.",
  "game_id": "<uuid>",
  "created_at": "2025-07-12T10:29:00Z",
  "updated_at": "2025-07-12T10:29:00Z",
  "connections": [
    {
      "id": "<uuid>",
      "label": "Mossy Trail",
      "description": "A winding path of soft moss.",
      "to_room_id": "<uuid>"
    }
  ]
}


Error Response (404 Not Found):{
  "errors": ["Room not found"]
}



Players
POST /api/v1/players
Creates a new player in a game with a starting room.

Method: POST
Endpoint: /api/v1/players
Headers: Authorization: Bearer <token>
Payload:{
  "player": {
    "current_room_id": "<uuid>",
    "game_id": "<uuid>"
  }
}


Expected Response (201 Created):{
  "id": "<uuid>",
  "current_room_id": "<uuid>",
  "game_id": "<uuid>",
  "created_at": "2025-07-12T10:29:00Z",
  "updated_at": "2025-07-12T10:29:00Z"
}


Error Response (422 Unprocessable Entity):{
  "errors": ["Current room must exist", "Room must belong to the specified game"]
}



GET /api/v1/players/:id
Fetches a player’s current state.

Method: GET
Endpoint: /api/v1/players/:id
Headers: Authorization: Bearer <token>
Payload: None
Expected Response (200 OK):{
  "id": "<uuid>",
  "current_room_id": "<uuid>",
  "game_id": "<uuid>",
  "created_at": "2025-07-12T10:29:00Z",
  "updated_at": "2025-07-12T10:29:00Z",
  "current_room": {
    "id": "<uuid>",
    "title": "Twilight Hollow",
    "description": "A stone chamber.",
    "game_id": "<uuid>",
    "created_at": "2025-07-12T10:29:00Z",
    "updated_at": "2025-07-12T10:29:00Z",
    "connections": [
      {
        "id": "<uuid>",
        "label": "Mossy Trail",
        "description": "A winding path.",
        "to_room_id": "<uuid>"
      }
    ]
  }
}


Error Response (404 Not Found):{
  "errors": ["Player not found"]
}



POST /api/v1/players/:id/move
Moves a player to a connected room or handles "look"/"examine" actions.

Method: POST
Endpoint: /api/v1/players/:id/move
Headers: Authorization: Bearer <token>
Payload:{
  "action_text": "string" // e.g., "mossy trail" or "look"
}


Expected Response (Move) (200 OK):{
  "message": "Moved through Mossy Trail.",
  "player": {
    "id": "<uuid>",
    "current_room_id": "<uuid>",
    "game_id": "<uuid>",
    "created_at": "2025-07-12T10:29:00Z",
    "updated_at": "2025-07-12T10:29:00Z"
  },
  "room": {
    "id": "<uuid>",
    "title": "Mossy Glade",
    "description": "A clearing with glowing flowers.",
    "game_id": "<uuid>",
    "created_at": "2025-07-12T10:29:00Z",
    "updated_at": "2025-07-12T10:29:00Z"
  },
  "connections": [
    {
      "id": "<uuid>",
      "label": "Shadowy Path",
      "description": "A dark trail leading back.",
      "to_room_id": "<uuid>"
    }
  ]
}


Expected Response (Look) (200 OK):{
  "message": "You look around Twilight Hollow.",
  "room": {
    "id": "<uuid>",
    "title": "Twilight Hollow",
    "description": "A stone chamber.",
    "game_id": "<uuid>",
    "created_at": "2025-07-12T10:29:00Z",
    "updated_at": "2025-07-12T10:29:00Z",
    "connections": [...]
  }
}


Error Response (422 Unprocessable Entity):{
  "errors": ["Destination room not yet generated"]
}


Error Response (400 Bad Request):{
  "errors": ["Invalid action. Use a connection label or \"look\"."]
}



Themes
GET /api/v1/themes
Lists all available themes (public, no authentication required).

Method: GET
Endpoint: /api/v1/themes
Payload: None
Expected Response (200 OK):[
  {
    "id": "<uuid>",
    "name": "fantasy",
    "description": "A world of magic and mystery.",
    "created_at": "2025-07-12T10:29:00Z",
    "updated_at": "2025-07-12T10:29:00Z"
  },
  {
    "id": "<uuid>",
    "name": "action",
    "description": "A high-energy world of danger.",
    "created_at": "2025-07-12T10:29:00Z",
    "updated_at": "2025-07-12T10:29:00Z"
  },
  {
    "id": "<uuid>",
    "name": "adventure",
    "description": "A vast world of exploration.",
    "created_at": "2025-07-12T10:29:00Z",
    "updated_at": "2025-07-12T10:29:00Z"
  }
]


