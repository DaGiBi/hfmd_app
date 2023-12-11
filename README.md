HFMD Digital Mobile Diagnosis App using VGG-16

Overview
This repository contains the source code for an Hand, Foot, and Mouth Disease (HFMD) Digital Mobile Diagnosis App. 
The application utilizes the VGG-16 model for HFMD recognition, making it a powerful tool for early detection and tracking of the disease. 
The app is developed using Flutter and integrates various technologies such as MongoDB Atlas, OpenStreetMap, TFLite_Flutter, Flutter Syncfusion Chart, and the VGG-16 model.

Features
HFMD Recognition
Utilizes the VGG-16 model for accurate Hand, Foot, and Mouth Disease recognition.
Provides an efficient and reliable diagnosis tool for medical professionals.
Hotspot Tracking
Enables tracking of disease hotspots using OpenStreetMap integration.
Helps in identifying and monitoring areas with a higher incidence of HFMD cases.
Data Visualization
Utilizes Flutter Syncfusion Chart for comprehensive data visualization.
Presents HFMD-related data in an easily understandable graphical format.
Offline Mode
Supports offline functionality to ensure users can access essential features even without an internet connection.
Enhances the app's usability in areas with limited connectivity.

Technologies Used
Flutter: Cross-platform framework for building mobile applications.
MongoDB Atlas: Cloud-based database for storing and managing application data.
OpenStreetMap: Provides mapping and location data to enable hotspot tracking.
TFLite_Flutter: Integrates TensorFlow Lite for efficient and optimized machine learning inference on mobile devices.
Flutter Syncfusion Chart: Enables the creation of visually appealing and interactive charts for data representation.

Getting Started
To run the app locally, follow these steps:

Clone the repository:

git clone https://github.com/DaGiBi/hfmd_app.git

Install dependencies:

flutter pub get

Configure MongoDB Atlas:

Obtain your MongoDB Atlas connection string.

Update the connection string in the app code.

Run the app:

flutter run



Contributing
Contributions are welcome! If you have ideas for improvements or new features, feel free to submit a pull request.

License
This project is licensed under the MIT License.

Acknowledgments
Special thanks to the developers of Flutter, MongoDB, OpenStreetMap, TensorFlow Lite, and Syncfusion for their incredible tools and libraries that made this project possible.
Feel free to reach out with any questions or issues. Happy coding!
