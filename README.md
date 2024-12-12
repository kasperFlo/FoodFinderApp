# GroceryStoreApp

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

## Services and Functionalities for the User

- **Advanced Search and Filtering:** Search by keywords, apply filters for types of food or distance.
- **Restaurant Browsing and Categorization:** Explore restaurants organized by cuisine or location.
- **Favorites Management:** Save and revisit liked restaurants.
- **User-Friendly Interfaces:** Designed with Figma for a modern and accessible experience.
- **Multiple Contact Options:** Access contact details such as phone numbers and website links.
- **Personalized Recommendations:** AI-driven suggestions for restaurants and dishes based on preferences.

---

## Use Cases for the App

1. **Discover Restaurants:**
   - Browse restaurant options based on geolocation.
   - Filter restaurants by cuisine or distance.

2. **View Details:**
   - Access comprehensive restaurant information such as ratings, reviews, and contact details.

3. **Save Favorites:**
   - Mark and save favorite restaurants for quick access.
   - View saved restaurants in a dedicated section.

4. **Get Suggestions:**
   - Use the Gemini feature to ask for meal recommendations or general dining-related questions.

5. **Plan Visits:**
   - Organize saved restaurants and plan future visits.

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
    *   Developed backend ViewModels for favorites and store lists.
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


