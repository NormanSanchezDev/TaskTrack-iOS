import SwiftUI

/**
 * First step: day, month and year wheels, then Next to pick the time.
 */
struct DueDateDayStep: View {
    @Bindable var draft: DueDateDraft
    let onDone: () -> Void

    @State private var isShowingTime = false

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 4) {
                DueDateWheel(title: "Day", values: draft.days, selection: $draft.day, isPadded: false)
                DueDateWheel(title: "Month", values: draft.months, selection: $draft.month)
                DueDateWheel(title: "Year", values: draft.years, selection: $draft.year, isPadded: false)
            }

            TTButton(model: .init(text: "Next", type: .filled) {
                isShowingTime = true
            })
        }
        .navigationTitle("Date")
        .navigationDestination(isPresented: $isShowingTime) {
            DueDateTimeStep(draft: draft, onDone: onDone)
        }
    }
}

#Preview {
    NavigationStack {
        DueDateDayStep(draft: DueDateDraft(date: .now)) {}
    }
}
