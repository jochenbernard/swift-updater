// swiftlint:disable sorted_enum_cases

/// A type which represents progress.
public enum SUProgress {
    /// Progress represented by a fraction.
    ///
    /// - Parameter fraction: The fraction.
    case fraction(_ fraction: Double)

    /// Progress represented by a completed number of bytes relative to a total number of bytes.
    ///
    /// - Parameters:
    ///   - completed: The completed number of bytes.
    ///   - total: The total number of bytes.
    case bytes(completed: Int64, total: Int64)

    /// The progress fraction.
    public var fraction: Double {
        switch self {
        case let .fraction(fraction):
            fraction

        case let .bytes(completed, total):
            Double(completed) / Double(total)
        }
    }
}
