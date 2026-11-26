import SwiftUI

/**
 * One wheel column of numbers driven by the Digital Crown.
 * The label appears above the column while it has focus.
 */
struct DueDateWheel: View {
    let title: LocalizedStringKey
    let values: [Int]
    @Binding var selection: Int
    var isPadded = true

    var body: some View {
        Picker(title, selection: $selection) {
            ForEach(values, id: \.self) { value in
                Text(text(for: value))
                    .monospacedDigit()
                    .tag(value)
            }
        }
        .pickerStyle(.wheel)
        .frame(maxWidth: .infinity)
    }

    private func text(for value: Int) -> String {
        isPadded
            ? value.formatted(.number.precision(.integerLength(2)).grouping(.never))
            : value.formatted(.number.grouping(.never))
    }
}
