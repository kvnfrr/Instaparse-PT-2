# Project 3 - Instaparse

Submitted by: **Kevin Ferrer**

**Instaparse** is an app that allows users to capture and share real-time posts similar to BeReal, where users must upload their own photo before viewing others. Users can interact with posts through comments, and each post includes a timestamp and location.

Time spent: **X** hours spent in total

## Required Features

The following **required** functionality is completed:

- [x] User can launch camera to take photo instead of photo library
  - [x] Users without iPhones to demo this feature can manually add unique photos to their simulator's Photos app
- [x] Users can intereact with posts via comments, comments will have user data such as username and name
- [x] Posts have a time and location attached to them
- [x] Users are not able to see other users’ photos until they upload their own.

## Optional Features

The following **optional** features are implemented:

- [ ] User receive notifcation when it is time to post

## Additional Features

The following **additional** features are implemented:

- [x] Pull-to-refresh feed
- [x] Persistent login using Parse current user
- [x] Image compression before upload
- [x] Clean UI layout for posts and comments

## Video Walkthrough

<img src="https://img.youtube.com/vi/ll67GQD0W-Y/0.jpg" width="400"/>

[Watch Video Walkthrough](https://youtu.be/ll67GQD0W-Y)

## Notes

Describe any challenges encountered while building the app.

- Debugging IBOutlet connection crashes (unexpectedly found nil errors)
- Managing async queries for posts and comments
- Implementing blur logic based on time comparisons
- Handling camera permissions and simulator limitations

## License

    Copyright [2026] Kevin Ferrer

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
