import SwiftUI

struct HomeView: View {
    @Environment(AppRouter.self) private var router

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

                TTButton(
                    model: .init(text: "Add task", trailingIcon: "plus", type: .filled) {
                        router.push(.taskForm(taskID: nil, projectID: nil))
                    }
                )

                TTButton(
                    model: .init(text: "My tasks", trailingIcon: "list.bullet", type: .outlined) {
                        router.push(.taskList)
                    }
                )

                TTButton(
                    model: .init(text: "Projects", trailingIcon: "folder", type: .outlined) {
                        router.push(.projectList)
                    }
                )
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
