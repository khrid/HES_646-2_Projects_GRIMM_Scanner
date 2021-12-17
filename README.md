# grimm_scanner

Grimm_scanner is a cross-platform app (iOS, Android, Web) created by a school team in the context of a school project.

It's a Flutter application in Dart language with a Firebase Firestore database.

It was made for the Grimm Association to manage their inventory with generated QR Codes.

In order to use the application, users have to login to their existing account or sign up into a new one.


### Users can have a total of 3 roles :
- Member
- ObjectManager
- Administrator


### Several functionnalities :
- Scan QR codes to modify object status (borrowed / available)
- Track the object history (date, user, status)
- Create and add new objects, modify, delete
- Create and add new categories, modify, delete
- Create and add new users accounts


## Built with
- Dart v202.8531 
- Flutter v58.0.1


## Libraries 
Several libraries were used to develop the functionalities ofour project. They can be found in the pubspec.yaml file.


## Folder structure
- assets: files that are use by all the application. The main dart file is constants.dart,
- localization: files required for the translation of the app,
- models: models of the collectionsand documentsfrom Firebase,
- pages: allthe visible pages of the application, login, scan, etc...,
- service: provides the authentication servicefor Firebase Authentication,
- utils: files that are “toolboxes” for the application, in this case QR tools,
- widgets: custom widgets that were developed for the need of the application.


## Contributors 
It's a school project so actual contributors are 4 students in HES-SO Valais/Wallis in Switzerland.
