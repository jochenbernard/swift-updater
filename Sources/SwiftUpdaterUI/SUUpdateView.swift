import SwiftUI
import SwiftUpdater

/// A view that shows the progress toward completion of an update.
public struct SUUpdateView: View {
    private let state: SUUpdate.State

    private static let byteCountFormatter = ByteCountFormatter()

    /// Creates an update view for showing update progress.
    ///
    /// - Parameter update: The update.
    public init(_ update: SUUpdate) {
        self.init(state: update.state)
    }

    init(state: SUUpdate.State) {
        self.state = state
    }

    public var body: some View {
        ProgressView(
            value: value,
            label: {
                Text("Updating...")
            },
            currentValueLabel: {
                HStack {
                    currentValueLabel

                    Spacer()

                    progressLabel
                }
            }
        )
        .tint(tint)
    }

    private var value: Double? {
        switch state {
        case .waiting, .applying, .relaunching:
            nil

        case .downloading(let progress), .extracting(let progress):
            progress?.fraction

        case .completed, .failed, .canceled:
            1.0
        }
    }

    private var currentValueLabel: some View {
        switch state {
        case .waiting:
            Text("Waiting to start update...")

        case .downloading:
            Text("Downloading update...")

        case .extracting:
            Text("Extracting update...")

        case .applying:
            Text("Applying update...")

        case .relaunching:
            Text("Relaunching...")

        case .completed:
            Text("Update completed")

        case .failed:
            Text("Update failed")

        case .canceled:
            Text("Update canceled")
        }
    }

    @ViewBuilder private var progressLabel: some View {
        switch state {
        case .waiting, .applying, .relaunching, .completed, .failed, .canceled:
            EmptyView()

        case .downloading(let progress), .extracting(let progress):
            switch progress {
            case .fraction, nil:
                EmptyView()

            case let .bytes(completed, total):
                Text(Self.byteCountFormatter.string(fromByteCount: completed)) +
                Text(" of ") +
                Text(Self.byteCountFormatter.string(fromByteCount: total))
            }
        }
    }

    private var tint: Color? {
        switch state {
        case .waiting, .downloading, .extracting, .applying, .relaunching:
            nil

        case .completed:
            .green

        case .failed:
            .red

        case .canceled:
            .gray
        }
    }
}

private struct PreviewError: Error {}

#Preview("Update View Waiting") {
    SUUpdateView(state: .waiting)
        .padding()
}

#Preview("Update View Downloading") {
    SUUpdateView(
        state: .downloading(
            progress: .bytes(
                completed: 123_456_789,
                total: 987_654_321
            )
        )
    )
        .padding()
}

#Preview("Update View Extracting") {
    SUUpdateView(state: .extracting(progress: .fraction(0.5)))
        .padding()
}

#Preview("Update View Applying") {
    SUUpdateView(state: .applying)
        .padding()
}

#Preview("Update View Relaunching") {
    SUUpdateView(state: .relaunching)
        .padding()
}

#Preview("Update View Completed") {
    SUUpdateView(state: .completed)
        .padding()
}

#Preview("Update View Failed") {
    SUUpdateView(state: .failed(error: PreviewError()))
        .padding()
}

#Preview("Update View Canceled") {
    SUUpdateView(state: .canceled)
        .padding()
}
