import SwiftUI

/**
 * Second step: hour, minute and second wheels, then Done to confirm.
 */
struct DueDateTimeStep: View {
    @Bindable var draft: DueDateDraft
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 2) {
                DueDateWheel(title: "Hours", values: draft.hours, selection: $draft.hour)
                separator
                DueDateWheel(title: "Minutes", values: draft.minutesAndSeconds, selection: $draft.minute)
                separator
                DueDateWheel(title: "Seconds", values: draft.minutesAndSeconds, selection: $draft.second)
            }

            TTButton(model: .init(text: "Done", type: .filled, action: onDone))
        }
        .navigationTitle("Time")
    }

    private var separator: some View {
        Text(":")
            .font(.title3)
            .accessibilityHidden(true)
    }
}

#Preview {
    NavigationStack {
        DueDateTimeStep(draft: DueDateDraft(date: .now)) {}
    }
}
