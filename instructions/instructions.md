
# Product Requirements Document (PRD)

## 1. Project Overview

**Product Name:**  
AI Listing Video Generator

**Objective:**  
Automatically generate polished, 20-second real estate videos from preloaded MLS data. Videos are composed of a slideshow of property photos with smooth animations, text overlays displaying key property information, AI-generated voiceover narration, and AI-generated background music. The app is designed for real estate admirers, investors, and homebuyers who will browse properties through a full-screen, TikTok-style interface. Tiktok version of Zillow.

**Target Users:**  
- Consumers (real estate admirers, investors, homebuyers) browsing properties via a video-first interface.  
- Agents do not manually upload data; all listings are preloaded (via CSV and photo links/images).

**MVP Scope:**  
- **Phase 1 (Consumer Interaction):**  
  - Implement six consumer user journeys (detailed below) using static/dummy video content and basic listing data.  
- **Phase 2 (Core Back-End & Video Generation):**  
  - Implement preloaded MLS Data Management, Automated Video Generation, AI Voiceover Integration, Text Overlay, AI Music Generation, and Agno-driven orchestration.

---

## 2. Consumer User Stories (6 User Journeys)

1. **Video Feed Browsing:**  
   *As a consumer, I want to scroll through a full-screen, TikTok-style feed of property videos so that I can quickly discover and browse properties.*

2. **Property Details Overlay:**  
   *As a consumer, I want to tap on a property video to see an overlay with additional details (full description, address, price, number of bedrooms/bathrooms, etc.) so that I can better understand the property without leaving the video interface.*

3. **Liking a Property:**  
   *As a consumer, I want to like a property video so that I can indicate my interest and help signal its popularity.*

4. **Saving/Favoriting a Property:**  
   *As a consumer, I want to save or favorite a property listing so that I can easily review it later and compare it with other properties.*

5. **Reviewing Saved Properties:**  
   *As a consumer, I want to view a dedicated list or tab of all my saved properties so that I can quickly access and compare the listings I’ve marked as favorites.*

6. **Social Sharing:**  
   *As a consumer, I want to share a property video directly from the app to social media (e.g., TikTok, Facebook, Twitter) so that I can get opinions from friends or showcase properties I find appealing.*

---

## 3. Features & Requirements (Ordered by Phases)

### Phase 1: Consumer Interaction Features

#### 3.1 Consumer Interaction Features Overview
- These features enable consumers to browse, interact with, and share property content. During Phase 1, the video content may be dummy or placeholder assets, with static data for listings. This allows early testing and user feedback on the consumer experience.

#### 3.1.1 Video Feed Browsing & Property Details Overlay
- **Requirements:**
  - **Front-End:**  
    - Present a full-screen, vertical, auto-playing feed of property videos (placeholder videos if actual generation is not yet implemented).
    - Tapping a video opens a modal overlay with detailed property information (address, price, full description, features, etc.).
  - **Data:**  
    - Use listing data retrieved via the `GET /listing/{listingId}` endpoint.
  - **User Experience:**  
    - Smooth scrolling, auto-play, and a familiar TikTok-style interface.

#### 3.1.2 Liking a Property
- **Requirements:**
  - **Front-End:**  
    - Display a “like” icon on each video.
    - On tap, update the UI immediately (e.g., change icon color).
  - **Back-End:**  
    - **Endpoint:** `POST /like`
      - *Request Body:*
        ```json
        {
          "uid": "user123",
          "listingId": "TX-123456"
        }
        ```
      - *Response:*
        ```json
        {
          "status": "success",
          "message": "Listing liked."
        }
        ```
    - Increment a `likeCount` field in the listing’s document and optionally record the user's `uid` in a sub-collection to prevent duplicates.

#### 3.1.3 Saving/Favoriting a Property
- **Requirements:**
  - **Front-End:**  
    - Display a “save” icon on each video.
    - On tap, update the UI and add the listing to the user’s favorites.
  - **Back-End:**  
    - **Endpoints:**  
      - **POST `/favorite`**
        - *Request Body:*
          ```json
          {
            "uid": "user123",
            "listingId": "TX-123456"
          }
          ```
        - *Response:*
          ```json
          {
            "status": "success",
            "message": "Listing saved to favorites."
          }
          ```
      - **DELETE `/favorite`**
        - *Request Body:*
          ```json
          {
            "uid": "user123",
            "listingId": "TX-123456"
          }
          ```
        - *Response:*
          ```json
          {
            "status": "success",
            "message": "Listing removed from favorites."
          }
          ```

#### 3.1.4 Reviewing Saved Properties
- **Requirements:**
  - **Front-End:**  
    - Provide a dedicated “Favorites” tab or screen.
    - Display a list (or grid) of saved properties with thumbnail images and key details.
  - **Back-End:**  
    - **Endpoint:** `GET /favorites/{uid}`
      - *Response Example:*
        ```json
        [
          {
            "listingId": "TX-123456",
            "savedAt": "2025-02-03T12:00:00Z",
            "propertyDetails": { ... }
          },
          {
            "listingId": "TX-654321",
            "savedAt": "2025-02-03T13:00:00Z",
            "propertyDetails": { ... }
          }
        ]
        ```

#### 3.1.5 Social Sharing
- **Requirements:**
  - **Front-End:**  
    - Display a “share” icon on each video.
    - On tap, invoke the native mobile sharing functionality to share the video URL or snippet (with watermark “Powered by [AppName]”).
  - **Implementation Note:**  
    - Leverage native iOS share sheets; no additional back-end endpoint is required.

---

### Phase 2: Core Back-End & Video Generation Features

These features provide the automated video generation and enrichment functionalities that underpin the consumer experience.

#### 3.2.1 Preloaded MLS Data Management
- **Description:**  
  Ingest 10 listings from a provided CSV.
- **Requirements:**
  - **Data Schema (Firestore Collection: `listings`):**
    - `listingId` (String): e.g., "TX-123456"
    - `address` (Object): `street`, `city`, `state`, `zip`
    - `price` (Number)
    - `propertyType` (String)
    - `bedrooms` (Number)
    - `bathrooms` (Number)
    - `squareFeet` (Number)
    - `description` (String)
    - `features` (Array of Strings)
    - `photos` (Array of Strings): URLs or Firebase Storage references
    - `status` (String): “Active”
    - `listingDate` (ISO Date String)
    - `agent` (Object): `name`, `brokerage`
    - `likeCount` (Number, default 0)
  - **Import Process:**  
    - Use CSV import scripts or a Cloud Function to load the data into Firestore.

#### 3.2.2 Automated Video Generation
- **Description:**  
  Generate a 20-second video per listing using listing photos, text overlays, voiceover, and background music.
- **Requirements:**
  - **Video Specs:**
    - Duration: 20 seconds (±2 seconds)
    - Resolution: 1080p, MP4 format
    - Use up to 8 photos (first 8 if more exist)
    - Apply smooth transitions (fade, Ken Burns effect)
    - Overlay a watermark: “Powered by [AppName]”
  - **Workflow:**
    1. **Trigger:**  
       - `POST /generateVideo` with a `listingId`.
    2. **Data Retrieval:**  
       - A Cloud Function fetches listing data from Firestore.
    3. **Call Video API:**  
       - **API:** Use **Shotstack API**
       - **Endpoint:** `POST https://api.shotstack.io/v1/render`
       - **Payload:**  
         - Array of image URLs (from `photos`)
         - Duration per image (20 seconds divided by number of images)
         - Animation effects parameters
         - Text overlay details (see Section 3.2.4)
         - Audio tracks: voiceover and background music URLs (from Sections 3.2.3 and 3.2.5)
    4. **Processing:**  
       - Poll for rendering status or use a webhook until the video is complete.
    5. **Storage:**  
       - Store video metadata in Firestore (`videos` collection) with fields:
         - `videoId` (auto-generated)
         - `listingId`
         - `videoUrl`
         - `status` (“completed”)
         - `createdAt` (timestamp)
  - **Variable Naming:**  
    - API Endpoint: `/generateVideo`
    - Firestore Collection: `videos`
    - Field: `videoUrl`

#### 3.2.3 AI Voiceover Integration
- **Description:**  
  Generate an AI-powered voiceover from listing details.
- **Requirements:**
  - **API:** Use **ElevenLabs API**
  - **Endpoint Details:**  
    - URL: `https://api.elevenlabs.io/v1/text-to-speech/{voice_id}`
    - Method: POST
    - *Payload Example:*
      ```json
      {
        "text": "Welcome to 123 Elm St, a beautiful 4-bed, 3-bath home listed at $500,000.",
        "voice_settings": {
          "stability": 0.75,
          "similarity_boost": 0.75
        }
      }
      ```
  - **Response:**  
    - Returns an MP3 audio URL.
  - **Environment Variables:**  
    - `ELEVENLABS_API_KEY`
    - `ELEVENLABS_VOICE_ID`
  - **Integration:**  
    - A helper Cloud Function `generateVoiceoverText(listing)` calls the API and returns the audio URL.

#### 3.2.4 Text Overlay and Styling
- **Description:**  
  Add text overlays to videos to display key property details.
- **Requirements:**
  - **Content:**  
    - Format: “[bedrooms] Bed | [bathrooms] Bath | [price] – [city], [state]”
    - Example: “4 Bed | 3 Bath | $500,000 – Austin, TX”
  - **Styling:**  
    - Font: Bold, sans-serif, white text with a subtle shadow.
    - Position: Lower third.
    - Duration: Display during the first slide or as defined by the timeline.
  - **Integration:**  
    - Include overlay configuration in the Shotstack API payload using the key `textOverlay` (with sub-keys such as `text`, `fontSize`, `position`, `startTime`, `duration`).

#### 3.2.5 AI Music Generation
- **Description:**  
  Add a background music track generated by AI.
- **Requirements:**
  - **API:** Use **Mubert API**
  - **Endpoint Details:**  
    - URL: `https://api.mubert.com/v2/track`
    - Method: POST
    - *Payload Example:*
      ```json
      {
        "duration": 20,
        "genre": "ambient",
        "mood": "uplifting"
      }
      ```
  - **Response:**  
    - Returns an MP3 audio URL.
  - **Environment Variable:**  
    - `MUBERT_API_KEY`
  - **Integration:**  
    - A Cloud Function calls the API and obtains the music track URL to include in the Shotstack payload.

#### 3.2.6 Agno-Driven Workflow Orchestration
- **Description:**  
  Use Agno (Phidata) to coordinate the multi-step video generation workflow.
- **Requirements:**
  - **Setup:**  
    - Define a workflow agent per Agno’s documentation ([Agno Docs](https://docs.phidata.com/more-examples)).
  - **Workflow Tasks:**
    1. `getListingData(listingId)` – Retrieves listing data from Firestore.
    2. `generateVoiceover(listing)` – Calls ElevenLabs API.
    3. `generateMusic(duration)` – Calls Mubert API.
    4. `renderVideo(listing, voiceoverUrl, musicUrl)` – Calls Shotstack API.
    5. `storeVideoMetadata(videoData)` – Stores video metadata in Firestore.
  - **Variable Naming:**  
    - Workflow file: `video_generation_workflow.yaml` (or similar)
    - Agent functions: `getListingData()`, `generateVoiceover()`, `generateMusic()`, `renderVideo()`, `storeVideoMetadata()`

---

## 4. Data Model

### 4.1 Listing Document (Firestore Collection: `listings`)
```json
{
  "listingId": "TX-123456",
  "address": {
    "street": "123 Elm St",
    "city": "Austin",
    "state": "TX",
    "zip": "78701"
  },
  "price": 500000,
  "propertyType": "Single Family Home",
  "bedrooms": 4,
  "bathrooms": 3,
  "squareFeet": 2500,
  "description": "Beautiful updated home in downtown Austin with a modern kitchen and spacious backyard.",
  "features": ["Modern Kitchen", "Spacious Backyard", "Swimming Pool"],
  "photos": [
    "https://example.com/photos/listing123_photo1.jpg",
    "https://example.com/photos/listing123_photo2.jpg",
    "... additional photo URLs ..."
  ],
  "status": "Active",
  "listingDate": "2025-02-01T00:00:00Z",
  "agent": {
    "name": "Jane Smith",
    "brokerage": "ABC Realty"
  },
  "likeCount": 0
}
```

### 4.2 Video Document (Firestore Collection: `videos`)
```json
{
  "videoId": "autoGeneratedId",
  "listingId": "TX-123456",
  "videoUrl": "https://cdn.example.com/videos/video_tx123456.mp4",
  "status": "completed",
  "createdAt": "2025-02-03T12:00:00Z"
}
```

### 4.3 User Favorites (e.g., Sub-collection in `users/{uid}/favorites`)
```json
{
  "listingId": "TX-123456",
  "savedAt": "2025-02-03T12:00:00Z"
}
```

---

## 5. API Contract

### 5.1 Consumer-Facing Endpoints (Phase 1)

#### 5.1.1 Like Endpoint
- **Endpoint:** `POST /like`
- **Request Headers:**  
  - `Content-Type: application/json`
- **Request Body:**
  ```json
  {
    "uid": "user123",
    "listingId": "TX-123456"
  }
  ```
- **Response:**
  ```json
  {
    "status": "success",
    "message": "Listing liked."
  }
  ```

#### 5.1.2 Favorite Endpoints
- **Save Favorite:**
  - **Endpoint:** `POST /favorite`
  - **Request Body:**
    ```json
    {
      "uid": "user123",
      "listingId": "TX-123456"
    }
    ```
  - **Response:**
    ```json
    {
      "status": "success",
      "message": "Listing saved to favorites."
    }
    ```
- **Remove Favorite:**
  - **Endpoint:** `DELETE /favorite`
  - **Request Body:**
    ```json
    {
      "uid": "user123",
      "listingId": "TX-123456"
    }
    ```
  - **Response:**
    ```json
    {
      "status": "success",
      "message": "Listing removed from favorites."
    }
    ```
- **Retrieve Favorites:**
  - **Endpoint:** `GET /favorites/{uid}`
  - **Response Example:**
    ```json
    [
      {
        "listingId": "TX-123456",
        "savedAt": "2025-02-03T12:00:00Z",
        "propertyDetails": { ... }
      },
      {
        "listingId": "TX-654321",
        "savedAt": "2025-02-03T13:00:00Z",
        "propertyDetails": { ... }
      }
    ]
    ```

#### 5.1.3 Listing Data Retrieval & Video Feed (Phase 1/2)
- **Listing Data:**  
  - **Endpoint:** `GET /listing/{listingId}`
  - **Response Example:**
    ```json
    {
      "listingId": "TX-123456",
      "address": {
        "street": "123 Elm St",
        "city": "Austin",
        "state": "TX",
        "zip": "78701"
      },
      "price": 500000,
      "propertyType": "Single Family Home",
      "bedrooms": 4,
      "bathrooms": 3,
      "squareFeet": 2500,
      "description": "Beautiful updated home in downtown Austin with a modern kitchen and spacious backyard.",
      "features": ["Modern Kitchen", "Spacious Backyard", "Swimming Pool"],
      "photos": [
        "https://example.com/photos/listing123_photo1.jpg",
        "https://example.com/photos/listing123_photo2.jpg"
      ],
      "status": "Active",
      "listingDate": "2025-02-01T00:00:00Z",
      "agent": {
        "name": "Jane Smith",
        "brokerage": "ABC Realty"
      },
      "likeCount": 10
    }
    ```
- **Video Feed:**  
  - For Phase 1, video assets may be placeholders.
  - **Endpoint (when available):** `POST /generateVideo`  
    *(Detailed in Phase 2)*

### 5.2 Core Back-End Endpoints (Phase 2)

#### 5.2.1 Generate Video Endpoint
- **Endpoint:** `POST /generateVideo`
- **Request Headers:**  
  - `Content-Type: application/json`
- **Request Body:**
  ```json
  {
    "listingId": "TX-123456"
  }
  ```
- **Response (Synchronous Example):**
  ```json
  {
    "videoId": "autoGeneratedId",
    "videoUrl": "https://cdn.example.com/videos/video_tx123456.mp4",
    "status": "completed"
  }
  ```
- **Alternate Asynchronous Response:**
  ```json
  {
    "videoId": "autoGeneratedId",
    "status": "processing"
  }
  ```
- **Errors:**
  - 400: Missing/invalid `listingId`
  - 404: Listing not found
  - 500: Internal server error

#### 5.2.2 Video Status Endpoint
- **Endpoint:** `GET /videoStatus/{videoId}`
- **Response Example:**
  ```json
  {
    "videoId": "autoGeneratedId",
    "videoUrl": "https://cdn.example.com/videos/video_tx123456.mp4",
    "status": "completed"
  }
  ```

---

## 6. Dependencies & Variable Naming Summary

- **Mobile & Front-End:**  
  - SwiftUI (iOS)

- **Backend & Hosting:**  
  - Firebase  
    - Firestore (Collections: `listings`, `videos`, `users`)  
    - Cloud Storage  
    - Cloud Functions  
    - Firebase Auth (if implemented)
  - Agno (Phidata) for workflow orchestration

- **External APIs:**  
  - Shotstack API  
    - Environment Variable: `SHOTSTACK_API_KEY`
  - ElevenLabs API  
    - Environment Variables: `ELEVENLABS_API_KEY`, `ELEVENLABS_VOICE_ID`
  - Mubert API  
    - Environment Variable: `MUBERT_API_KEY`
  - (Optional) OpenAI API

- **Data & Integration Tools:**  
  - CSV Import Scripts  
  - (Optional) Cloudinary

- **API Endpoints:**  
  - `/like`, `/favorite`, `/favorites/{uid}`, `/generateVideo`, `/videoStatus/{videoId}`, `/listing/{listingId}`

- **Naming Conventions:**  
  - Firestore Collections: `listings`, `videos`, `users`
  - JSON Fields: camelCase (e.g., `listingId`, `likeCount`, `videoUrl`)
  - Cloud Functions: `generateVideoForListing()`, `getListingData()`, `generateVoiceover()`, `generateMusic()`, `renderVideo()`, `storeVideoMetadata()`

---

## 7. Final Notes & Implementation Order

1. **Phase 1 – Consumer Interaction Implementation:**  
   - Set up basic listing retrieval endpoints (`GET /listing/{listingId}`) and load preloaded MLS data into Firestore.
   - Build the front-end (SwiftUI) for the TikTok-style video feed using dummy video assets.
   - Implement consumer interactions:
     - Video feed browsing & property details overlay.
     - Liking a property (`POST /like`).
     - Saving/favoriting a property (`POST /favorite` and `DELETE /favorite`).
     - Reviewing saved properties (`GET /favorites/{uid}`).
     - Social sharing using native share sheets.
   - Validate that all six consumer user journeys are working.

2. **Phase 2 – Core Back-End & Video Generation:**  
   - Implement CSV import for MLS data (if not already done).
   - Develop the automated video generation pipeline:
     - Preloaded MLS Data Management.
     - Automated Video Generation via Shotstack API.
     - AI Voiceover Integration via ElevenLabs API.
     - Text Overlay and Styling integration.
     - AI Music Generation via Mubert API.
   - Integrate Agno to orchestrate these steps.
   - Expose endpoints for video generation (`POST /generateVideo`) and status checking (`GET /videoStatus/{videoId}`).
   - Transition the front-end video feed from dummy assets to actual generated videos.

This ordered PRD provides clear, step-by-step guidance so that engineers can implement the consumer experience first and then integrate the more complex, automated video generation features.

