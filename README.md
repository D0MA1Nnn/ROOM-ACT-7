# Flutter Laboratory

This activity integrates DemoAuth, an arithmetic calculator, and the student social feed into a single Flutter app. The app opens at Login and shows Dashboard, Calculator, Social, and Profile after sign-in.

## Run in VS Code

Open the `flutter_laboratory` folder in VS Code. In its integrated terminal, run:

```sh
flutter pub get
flutter run -d chrome
```

Use the demo account `admin` / `admin123`, or select **Create an account** and sign in with the account you register. DemoAuth keeps one registered account in memory.

## Verify the activity

```sh
flutter analyze
flutter test
```

| Action | Expected result |
| --- | --- |
| Sign in as `admin` | Dashboard displays **Welcome, admin!** |
| Enter 20 and 5 in Calculator | Addition gives 25.0, subtraction 15.0, multiplication 100.0, and division 4.0. |
| Switch away from Calculator and return | Both inputs and the result are still present. |
| Create a Social post with a caption and an HTTPS image URL | The post displays the logged-in username. |
| Like a post, comment, then create another post | The first post retains its like and comment. |
| Open Profile and select Logout | The app returns to Login and Back cannot reopen the previous session. |

Calculator inputs, results, and social changes are kept while switching tabs during a session. Restarting the app clears demo registrations and session data.
