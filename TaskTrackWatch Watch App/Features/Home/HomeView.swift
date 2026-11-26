import SwiftUI

struct HomeView: View {
    @Environment(AppRouter.self) private var router

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                TTText(model: .init(text: "Welcome\nagain!", type: .title))
                TTText(model: .init(text: "Start to track\nyour tasks", type: .description))

                TTButton(
                    model: .init(text: "Add task", trailingIcon: "plus", type: .filled) {
                        router.push(.addTask)
                    }
                )
                .padding(.top, 4)

                TTButton(
                    model: .init(text: "My tasks", trailingIcon: "list.bullet", type: .outlined) {
                        router.push(.taskList)
                    }
                )
            }
            .padding(.horizontal, 4)
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
