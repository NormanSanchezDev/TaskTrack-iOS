import SwiftUI

struct HomeView: View {
    @Environment(AppRouter.self) private var router

    private let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                TTText(
                    model: .init(
                        text: "Start to track\nyour tasks",
                        type: .description,
                        alignment: .leading
                    )
                )

                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(HomeDestination.allCases) { destination in
                        HomeTile(destination: destination) {
                            router.push(destination.route)
                        }
                    }
                }
            }
        }
        .navigationTitle("TaskTrack")
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .environment(AppRouter())
}
