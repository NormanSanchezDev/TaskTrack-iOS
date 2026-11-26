import SwiftUI

@main
struct TaskTrackWatchApp: App {
    private let dependencies = Result { try AppDependencies.live() }

    var body: some Scene {
        WindowGroup {
            switch dependencies {
            case .success(let dependencies):
                ContentView(factory: ViewModelFactory(dependencies: dependencies))
            case .failure(let error):
                StartupErrorView(message: error.localizedDescription)
            }
        }
    }
}
