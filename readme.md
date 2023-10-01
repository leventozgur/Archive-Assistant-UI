# Archive Assistant UI

Archive Assistant UI is a macOS application that provides a user-friendly interface for managing iOS app distribution processes, powered by Archive Assistant Services. With this user interface, you can easily and quickly handle app distribution tasks. Archive Assistant UI allows you to perform the following tasks:

- Initiate a new distribution process
- View and manage the distribution queue
- Monitor and view the results of distribution processes

Archive Assistant UI is developed using the Swift programming language and is designed with the MVVM (Model-View-ViewModel) architecture. User information is securely stored in Keychain.

## Screenshots

<table>
<tr><img src="https://raw.githubusercontent.com/leventozgur/Archive-Assistant-UI/main/Screenshots/ss_01.png" alt="ss_01" width="600" style="border: 1px solid;"> </tr>
<tr> <img src="https://raw.githubusercontent.com/leventozgur/Archive-Assistant-UI/main/Screenshots/ss_02.png" alt="ss_02" width="600" style="border: 1px solid;"> </tr>
</table>

## Getting Started

To start using Archive Assistant UI, follow these steps:

1. Make sure that Archive Assistant Services is running on your computer.

2. Ensure that you have configured the necessary settings in Archive Assistant Services, and you have added your user information to `db.json`. For more information, please refer to the [documentation](https://github.com/leventozgur/Archive-Assistant-Services).

3. Before running the project, don't forget to edit the `AppName`, `Branches`, and `Schemes` enum classes.

4. Specify the IP address where Archive Assistant Services is running (e.g., `127.0.0.1:3000` or `localhost:3000`) in the designated field and click "Connect."

The rest is straightforward. With Archive Assistant UI, you can easily manage the distribution of your iOS applications.
