
---


**Quiz App** is an engaging and interactive application that allows users to test their knowledge across various categories and difficulty levels. 
Built with Flutter and integrated with Firebase, the app fetches trivia questions from the Open Trivia Database, tracks user scores,
and maintains a history of scores for each user.
Users can sign up, log in, and enjoy a seamless quiz experience with time-based questions and instant score updates.

## Features

- **User Authentication**: Sign up, log in, and log out functionalities using Firebase Authentication.
- **Dynamic Quiz Generation**: Fetches trivia questions from the Open Trivia Database based on user preferences for category, difficulty, and type.
- **Score Tracking**: Records and displays user scores, best scores, and score history.
- **Achievements**: Users can view their history of scores and achievements.
- **Leaderboards**: Displays the best scores of other users, fostering a competitive environment.
- **Time-Based Questions**: Each question is timed, adding an extra layer of challenge.
- **Interactive UI**: Engaging and user-friendly interface with real-time updates.
- **Background Music**: Background music to enhance the quiz experience.

## Installation

To get started with the Quiz App, follow these steps:

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-username/quiz-app.git
   cd quiz-app
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Set Up Firebase**:
    - Go to the [Firebase Console](https://console.firebase.google.com/).
    - Create a new Firebase project.
    - Add your Android and iOS apps to the Firebase project.
    - Download the `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) files and place them in the respective directories.
    - Enable Email/Password Authentication in the Firebase Console.
    - Enable Firestore Database and set up the required Firestore rules.

4. **Run the App**:
   ```bash
   flutter run
   ```

## File Structure

```plaintext
quiz-app/
├── android/
├── assets/
│   └── background.mp3
├── ios/
├── lib/
│   ├── authentification/
│   │   ├── sign_in.dart
│   │   ├── sign_up.dart
│   ├── config/
│   │   └── global.params.dart
│   ├── menu/
│   │   └── drawer.widget.dart
│   ├── pages/
│   │   ├── achievements.dart
│   │   ├── home.dart
│   │   ├── leaderboard.dart
│   │   ├── play.dart
│   │   ├── settings.dart
│   ├── user_scores.dart
│   ├── main.dart
│   ├── play_page.dart
├── pubspec.yaml
```

## Usage

1. **Sign Up or Sign In**: Users can create a new account or log in to an existing account.
2. **Choose Quiz Preferences**: Select the number of questions, category, difficulty, and type of quiz.
3. **Start the Quiz**: Answer the questions within the given time frame.
4. **View Scores**: After completing the quiz, view your score and score history.
5. **View Achievements**: Check your history of scores and achievements in the achievements section.
6. **Leaderboards**: See the best scores of other users on the leaderboards.
7. **Background Music**: Enjoy the quiz with engaging background music.

## Contributing

Contributions are welcome! If you would like to contribute to this project, please follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Make your changes and commit them (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature-branch`).
5. Open a Pull Request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For any inquiries or feedback, please contact:

[hachichamohamedali357@gmail.com](mailto:hachichamohamedali357@gmail.com)
- GitHub: [MohamedALI-H](https://github.com/MohamedALI-H)

---

