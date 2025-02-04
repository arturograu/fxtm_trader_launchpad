# FXTM Forex Tracker App

## Overview

Welcome to the **FXTM Forex Tracker App** assessment project. This Flutter application serves as a starting point for you to demonstrate your skills in Flutter development, API integration, real-time data handling, and implementing responsive UI designs that align with standard forex platforms.

---

## Project Description

The FXTM Forex Tracker App is designed to display real-time forex prices for selected currency pairs. When a user taps on a currency pair, they are navigated to a detail page showing historical price data with an interactive graph.

**Features to Implement:**

- **Real-Time Data Streaming:** Integrate with the Finnhub API to fetch and display live forex prices.
- **Historical Data and Graphs:** Fetch historical price data and display it using interactive charts.
- **Data Caching and State Management:** Optimize app performance by implementing efficient state management and caching strategies.
- **Error Handling:** Gracefully handle API connectivity issues and provide user feedback.
- **Responsive UI Design:** Ensure the app's UI is responsive and matches the design conventions of standard forex trading platforms.

---

## Screens to Implement

1. **Markets Screen (Price Tracker):**
   - Displays a list of currency pairs with real-time price updates.
   - Shows currency symbols, current prices, price changes, and percentage changes.
   - Uses up/down arrows to indicate price movement (green for up, red for down).

2. **History Screen (Trade History):**
   - Shows historical price data for a selected currency pair.
   - Includes an interactive graph displaying price trends over time.
   - Provides detailed trading information and statistics.

---

## Getting Started

### Prerequisites

- **Flutter SDK:** Ensure you have Flutter installed on your machine. [Install Flutter](https://flutter.dev/docs/get-started/install)
- **Finnhub API Key:** Sign up for a free API key from [Finnhub](https://finnhub.io/).

### Setup Instructions

1. **Clone the Repository**

   ```bash
   git clone https://gitlab.com/exinity-hiring/fxtm-trader-launchpad.git
   ```

2. **Navigate to the Project Directory**

   ```bash
   cd fxtm_forex_tracker
   ```

3. **Install Dependencies**

   ```bash
   flutter pub get
   ```

4. **Add Finnhub API Key**

5. **Run the App**

   - **Android:**

     ```bash
     flutter run -d android
     ```

   - **iOS:**

     ```bash
     flutter run -d ios
     ```

   - **Web:**

     ```bash
     flutter run -d chrome
     ```

---

## Project Structure

```
lib/
├── main.dart
├── models/
│   └── forex_pair.dart
├── pages/
│   ├── main_page.dart
│   └── history_page.dart
├── repositories/
│   └── forex_repository.dart
└── services/
    └── finnhub_service.dart
```

- **models/**: Data models representing the structure of forex data.
- **services/**: Classes responsible for making API calls to Finnhub.
- **repositories/**: Abstraction layer between services and UI components.
- **pages/**: UI screens of the application.

---

## Tasks to Complete

### 1. Implement Real-Time Price Updates

- **Objective:**
   - Replace the mock data in `finnhub_service.dart` with actual API calls to the Finnhub API.
   - Fetch real-time forex prices and ensure they update smoothly in the UI.

### 2. Fetch and Display Historical Data with Graphs

- **Objective:**
   - Implement the `HistoryPage` to display historical price data for a selected currency pair using an interactive chart.

- **Instructions:**
   - **API Endpoint:** Use the Finnhub API endpoint for forex candles.
      - [Forex Candles Endpoint Documentation](https://finnhub.io/docs/api/forex-candles)
   - **Implementation Steps:**
      - Update the `fetchHistoricalData` method in `finnhub_service.dart`.
      - Parse the historical data and prepare it for charting.
      - Use a charting library to display the data.
         - Recommended packages:
            - `charts_flutter`
            - `fl_chart`
      - Update `history_page.dart` to include the chart and relevant trading information.
   - **Considerations:**
      - Handle different timeframes (e.g., daily, hourly).
      - Provide options for users to select the timeframe.

### 3. Implement Data Caching and State Management

- **Objective:**
   - Optimize the app's performance by caching data and managing state efficiently.

- **Instructions:**
   - **State Management:**
      - Choose a state management solution:
         - `Provider`
         - `Bloc`
         - `Riverpod`
         - `GetX`
      - Implement it across the app to manage data and UI state.
   - **Data Caching:**
      - Cache frequently accessed data to reduce API calls.
      - Consider using packages like `hive` or `shared_preferences` for local storage.
   - **Implementation Steps:**
      - Implement caching in the repository layer.
      - Ensure that cached data is invalidated or refreshed appropriately.
   - **Considerations:**
      - Balance between up-to-date data and performance.
      - Handle cache expiration policies.

### 4. Handle API Errors Gracefully

- **Objective:**
   - Ensure the app provides a smooth user experience even when API errors or connectivity issues occur.

### 5. Enhance UI and Responsiveness

- **Objective:**
   - Improve the UI styling to match professional forex trading platforms.
   - Ensure the app is responsive across various devices and screen sizes.
---

## Notes

- **API Key Management:**
   - Do not hardcode your API key in the code.
   - Use environment variables or secure storage to manage your API key.

- **Mock Data:**
   - The app currently uses mock data with simulated price changes.
   - Your task is to replace this with real data from the Finnhub API.

- **UI Design:**
   - The app displays currency pairs with up/down arrows indicating price movement, similar to standard forex platforms.
   - Enhance the UI to closely match the look and feel of professional forex trading apps.

- **Real-Time Data Streaming:**
   - If using WebSockets, handle the connection lifecycle properly.
   - Ensure the app remains responsive during data updates.

- **Testing:**
   - Write comprehensive test cases to validate user interactions and data handling.
   - Cover edge cases, such as API failures and varying network conditions.

---

## Evaluation Criteria

Your submission will be evaluated based on the following criteria:

### **Code Quality**

- **Clarity and Organization:**
   - Code is well-organized, with a clear structure and meaningful naming conventions.
- **Best Practices:**
   - Adherence to Flutter and Dart best practices.
   - Clean architecture and separation of concerns.
- **Functionality:**
   - Correct implementation of the required features.
   - Efficient and effective use of Flutter widgets and tools.

### **Testing**

- **Comprehensiveness:**
   - Adequate test coverage for both UI interactions and data handling.
- **Quality:**
   - Tests are reliable, well-written, and validate key functionality.
- **Edge Cases:**
   - Consideration of various scenarios, including error conditions and unusual user behaviors.

### **Documentation**

- **README File:**
   - Clear setup instructions and project overview.
   - Explanation of architecture and design decisions.
- **Code Documentation:**
   - Comments explaining complex logic or important sections.
   - Documentation of key components and state management practices.

### **User Experience**

- **UI/UX Design:**
   - Professional and intuitive user interface.
   - Responsive design across different devices and orientations.
- **Performance:**
   - Smooth animations and transitions.
   - Efficient data handling without unnecessary delays.

---

## Submission Instructions

1. **Ensure the App Runs Successfully**

   - Test the app thoroughly on at least one platform (Android, iOS, or Web).
   - Ensure there are no runtime errors or crashes.

2. **Prepare the Codebase**

3. **Update Documentation**

   - Include any additional notes or explanations in the `README.md` file.
   - Document any assumptions or decisions you made during development.

4. **Package the Project**

   - Zip the entire project directory, excluding build and cache files.
   - Include the `pubspec.lock` file to ensure dependency versions are preserved.

5. **Submit Your Work**

---

## Additional Resources

- **Flutter Documentation:** [https://flutter.dev/docs](https://flutter.dev/docs)
- **Dart Documentation:** [https://dart.dev/guides](https://dart.dev/guides)
- **Finnhub API Documentation:** [https://finnhub.io/docs/api](https://finnhub.io/docs/api)
- **State Management in Flutter:**
   - [Provider Package](https://pub.dev/packages/provider)
   - [Bloc Library](https://bloclibrary.dev/#/)
   - [Riverpod Package](https://riverpod.dev/)
- **Charting Libraries:**
   - [charts_flutter](https://pub.dev/packages/charts_flutter)
   - [fl_chart](https://pub.dev/packages/fl_chart)
- **Connectivity Detection:**
   - [connectivity_plus](https://pub.dev/packages/connectivity_plus)

---

## Contact Information

If you have any questions or need clarification, please reach out to:

- **Contact Person:** [Your Name]
- **Email:** [your.email@example.com]

---

**Good luck, and we look forward to seeing your implementation!**