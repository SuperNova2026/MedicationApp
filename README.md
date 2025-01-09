# Mobile Healthcare App

## Description
This project is a mobile healthcare application aimed at users in the healthcare system introduced in the first practice of the course. It allows users to consult prescribed medications, mark the medications they've taken, and receive notifications for upcoming doses.

## Technologies Used
- **Flutter** - Framework for building natively compiled applications for mobile.
- **Dart** - Programming language used with Flutter for app development.

## Features
- **Medication Tracking**: Users can consult their prescribed medications for the next time period (e.g., hours, days).
- **Marking Doses**: Users can mark which doses they have taken.
- **Notifications**: (Optional) The app can send notifications 5 minutes before the scheduled dose.
- **Responsive Design**: Optimized for both mobile phones and smartwatches.

## Tasks Breakdown

### Task 1: Interface Design
1. **Use Cases**: Identify and document the relevant use cases for the target users.
2. **UI Design**: Create mobile and smartwatch interfaces that adjust to the device configuration. Include error management and feedback elements.
3. **Architectural Pattern**: Choose an appropriate architectural pattern for state management, ensuring that the view component is independent of the state/model.
4. **Software Design**: Create UML diagrams to document the static and dynamic design of the application using [Mermaid](https://github.blog/2022-02-14-include-diagrams-markdown-files-mermaid/).

### Task 2: App Implementation
1. **App Development**: Implement the app based on the designs and architectural pattern selected in Task 1 using **Flutter**.
2. **Optional**: Implement notifications handling.
3. **Error Management**: Ensure proper error handling, especially for I/O operations. The app should inform the user about any errors that occur.

### Task 3: End-to-End Testing
1. **End-to-End Tests**: Implement end-to-end tests for various use cases.
2. **Error Testing**: Implement tests for I/O errors and user input errors.

## Installation
1. Clone the repository:
    ```bash
    git clone https://github.com/your-username/mobile-healthcare-app.git
    ```
2. Install dependencies:
    ```bash
    flutter pub get
    ```
3. Run the app:
    ```bash
    flutter run
    ```

## License
This project is open-source and available under the MIT License.

## Author
- **Valeria Isela Morales Romer** - Developer

## Acknowledgments
- This project is part of the "Interfaz Persona-Maquina" course at Universidad Da Coruña.
