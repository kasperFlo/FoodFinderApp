# FoodFinderApp

Our app uses geolocation services to connect users with a wide range of restaurants, allowing them to discover and explore dining options with ease. Users can search for restaurants based on their current location or a desired location, filter results by cuisine or distance, and view detailed information about each restaurant. The app provides a convenient and efficient way to find and save restaurants, catering to food enthusiasts, travelers, and anyone looking for a personalized dining experience. Additionally, the app offers meal suggestions and answers general inquiries through the Gemini feature, making it a versatile tool for decision-making.

The purpose of this app is to simplify the process of discovering restaurants, save users time in finding the perfect place to dine, and provide an engaging way to explore local and mainstream dining options. By integrating user-friendly design and powerful APIs, the app ensures a seamless experience for everyone, from casual diners to food connoisseurs.

---

## Key Features

### Restaurant Discovery and Filtering
- **Geolocation Services:** Find restaurants near the user's current or desired location.
- **Filtering Options:** Filter results by type of cuisine or distance.
- **Restaurant Cards:** Display cards with essential details, including:
  - Name
  - Address
  - Phone number
  - Website links
  - Ratings
  - Reviews

### Favorites and Core Data Integration
- **Save Favorites:** Users can "like" a restaurant card to save it for future reference.
- **Favorites View:** A dedicated view displays saved restaurants, helping users revisit or remember their favorite places.

### Gemini Suggestions
- **Meal Suggestions:** Personalized meal recommendations based on user preferences.
- **General Questions:** Allows users to ask questions, making the feature flexible and engaging.

---
![simulator_screenshot_B7F34647-06CC-4A96-AE90-C2EB8C8B0873](https://github.com/user-attachments/assets/df766ead-24fc-4bce-8e88-c6ec9a968e59)

![simulator_screenshot_664C74D8-9A46-47B5-BFA5-E51CFF83B231](https://github.com/user-attachments/assets/5251df6f-b173-4df6-a1a4-f3f26df19893)

![simulator_screenshot_38FFB30B-32A6-44B2-AB46-807E1142540C](https://github.com/user-attachments/assets/7d47e0b0-c9b1-49d9-ae9b-510f79d767bc)

![simulator_screenshot_87ED1B58-8FC5-43D7-B599-7899C0F39E57](https://![simulator_screenshot_633F46D5-6399-42E3-B9A3-89C0AC4D6B60](https://github.com/user-attachments/assets/ae3d8b3c-d12b-4e64-914d-758c6b56fcc8)

github.com/user-attachments/assets/a52c13b6-fa91-4cec-856a-6c0b6dacb2c3)
---

## Technologies Used

- **Google Places API:** Provides restaurant data including reviews, ratings, and contact information.
- **Gemini API:** Facilitates intelligent meal suggestions and general inquiries.
- **Core Data:** Enables saving and managing user-selected favorites.
- **MVVM Architecture:** Ensures a clean, maintainable, and scalable code structure.
- **Figma Designs:** Delivers a visually appealing and user-friendly interface.

---

## Work Distribution

### Members:

**Florian:**
*   **Backend Development:**
    *   Developed the GoogleMapsInteractionService, handling backend interaction with the Google Places API for fetching nearby stores based on current *or* user-chosen location, along with backend support for loading store photos.
    *   Developed backend ViewModels for favourites and store lists.
    *   Implemented core data persistence, utilizing a specialized nearby search based on Place ID and latitude/longitude to retrieve and store data, avoiding redundant API calls for populating the local store list.
    *   Refactored backend favouriting logic to integrate with core data, including a significant rework of the initial implementation.
    *   Implemented active geolocation tracking *and* refactored filtering functionalities from view to ViewModel.

*   **Frontend Development:**
    *   Implemented HomePage and basic navigation routing.
    *   Implemented photo handling and display on UI.
    *   Refactored frontend filters in the store list view to use the ViewModel.

**Suthakaran:**

*   **Frontend Development:**
    *   Created UI components and interface based on Figma designs (cards, store detail view with interactive elements, list view with infinite scrolling, and a responsive nav bar).
    *   Developed the AI chat page with an interactive message display enabling specific conversations.
    *   Implemented initial frontend favouriting logic and UI for the store list and favourites view pages. 
    *   Implemented initial search filters on the storeListView.
*   **Other:**
    *   Authored project documentation (README).

---

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/username/projectname.git
   ```
2. Navigate to the project directory:
   ```bash
   cd projectname
   ```
3. Install dependencies:
   ```bash
   pod install
   ```
4. Open the `.xcworkspace` file in Xcode:
   ```bash
   open projectname.xcworkspace
   ```
5. Configure API keys for Google Places API and Gemini API.
6. Build and run the app on a simulator or connected iOS device.

---

## Future Enhancements

- Expand filtering options to include price range and dietary preferences.
- Add map view for visualizing restaurant locations.
- Enable sharing of favorite restaurants with friends.
- Implement notifications for restaurant promotions and updates.


