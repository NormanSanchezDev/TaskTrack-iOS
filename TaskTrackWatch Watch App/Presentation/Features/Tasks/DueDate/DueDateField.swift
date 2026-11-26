import SwiftUI

/**
 * Form row that shows the due date and opens the two-step picker.
 * The picker starts on the current value and only writes back on Done.
 */
struct DueDateField: View {
    @Binding var selection: Date

    @State private var draft: DueDateDraft?
    @State private var isPicking = false

    var body: some View {
        Button(action: startPicking) {
            VStack(alignment: .leading) {
                Text("Due date")
                Text(selection, format: .dateTime.day().month(.abbreviated).year().hour().minute())
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationDestination(isPresented: $isPicking) {
            if let draft {
                DueDateDayStep(draft: draft, onDone: finish)
            }
        }
    }

    private func startPicking() {
        draft = DueDateDraft(date: selection)
        isPicking = true
    }

    private func finish() {
        if let draft {
            selection = draft.date
        }
        isPicking = false
    }
}
