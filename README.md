# FetchBites

### Summary
FetchBites is an iOS recipe browsing application built with SwiftUI that showcases modern iOS development practices. The app provides a seamless experience for browsing recipes, with features including:

[Insert screenshots/video showing:]

[![FetchBites Demo]](https://github.com/user-attachments/assets/222a9fef-46fa-4f4d-af62-a526eb940a0b)


- Main recipe list with custom-designed cards
- Full-screen image viewing capability
- Error state handling
- Empty state presentation
- Dark mode support with adaptive typography
- Loading states with skeleton views

### Focus Areas
In developing this application, I chose to prioritize three main areas:

First, I focused heavily on user experience and interface design. I implemented custom transitions, skeleton loading views, and adaptive color schemes to ensure the app feels polished and native to iOS. I paid particular attention to error states, ensuring users always understand the current app state and have clear paths to recovery.

Second, I emphasized code architecture and maintainability. I implemented a clean architecture pattern with clear separation of concerns, allowing for easy testing and future modifications. The networking layer is built with async/await for modern concurrency handling, and I developed a custom image caching system to optimize performance and reduce network usage.

Third, I invested significant effort in testing. The project includes comprehensive unit tests for the business logic and networking layers, along with UI tests that verify critical user flows including error handling and empty states. I implemented custom test helpers and mocks to ensure thorough coverage of edge cases.

### Time Spent
Total time: Approximately 6 hours, distributed across:
- Initial setup and architecture: 1 hours
- Core functionality implementation: 2 hours
- UI/UX refinement: 1.5 hours
- Testing and documentation: 1.5 hours

### Trade-offs and Decisions
Several key trade-offs shaped my implementation approach:

I chose to implement a custom image caching solution rather than using a third-party library. While this required more upfront development time, it allowed me to maintain the "no external dependencies" requirement while providing precise control over caching behavior and memory usage.

When handling malformed data, I decided to treat it as an error state rather than attempting to partially display malformed recipes. This trade-off prioritizes data integrity and consistent user experience over potentially displaying partial information.

For YouTube video playback, I opted for a simple WebView implementation rather than building a custom video player. This decision balanced development time against feature completeness, providing basic video functionality while meeting core requirements.

### Weakest Part of the Project
The image caching implementation, while functional, could be more sophisticated. The current solution handles basic caching scenarios well, but could be improved with:
- More granular cache eviction policies
- Disk caching for persistence across app launches
- Better memory management for large images
- Preloading of images for smoother scrolling

### Additional Information
The project demonstrates my approach to building production-ready iOS applications. I maintained a focus on code quality throughout, using Swift's type system to prevent runtime errors and implementing comprehensive error handling. The codebase follows SOLID principles and emphasizes protocol-oriented design for flexibility and testability.

All UI elements are built using SwiftUI, leveraging the latest platform capabilities while maintaining support for iOS 16 and above. The app handles all required endpoints gracefully, including proper handling of malformed data and empty states.

The implementation includes several bonuses beyond the basic requirements, such as smooth transitions between states, skeleton loading views, and comprehensive test coverage. These additions showcase my attention to detail and commitment to delivering polished user experiences.
