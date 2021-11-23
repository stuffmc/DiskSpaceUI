//
//  Highly based on https://github.com/scriptingosx/diskspace
//
//  Created by StuFF mc on 23.11.21.
//

import SwiftUI

@main
struct DiskSpace: App {
    @State private var humanReadable = true {
        didSet {
            compute()
        }
    }
    @State private var available = ""
    @State private var important = ""
    @State private var opportunistic = ""
    @State private var total = ""

    var body: some Scene {
        WindowGroup {
            Form {
                Toggle("Human Readable", isOn: $humanReadable)
                    .font(.body.bold())
                label("Available", for: available)
                label("Important", for: important)
                label("Opportunistic", for: opportunistic)
                label("Total", for: total)
                    .font(.subheadline.bold())
            }
            .onAppear {
                compute()
            }
        }
    }

    private func label(_ text: String, for value: String) -> some View {
        HStack {
            Text(text)
                .font(.subheadline)
            Spacer()
            Text(value)
        }
    }

    private func capacity(_ int: Int) -> String {
        capacity(Int64(int))
    }

    private func capacity(_ int: Int64) -> String {
        humanReadable ? ByteCountFormatter().string(fromByteCount: int) : String(int)
    }

    private func compute() {
        do {
            let values = try URL(fileURLWithPath: NSHomeDirectory()).resourceValues(forKeys: [.volumeAvailableCapacityKey,
                                                                                              .volumeAvailableCapacityForImportantUsageKey,
                                                                                              .volumeAvailableCapacityForOpportunisticUsageKey,
                                                                                              .volumeTotalCapacityKey])
            if let availableCapacity = values.volumeAvailableCapacity {
                available = capacity(availableCapacity)
            }
            if let importantCapacity = values.volumeAvailableCapacityForImportantUsage {
                important = capacity(importantCapacity)
            }
            if let opportunisticCapacity = values.volumeAvailableCapacityForOpportunisticUsage {
                opportunistic = capacity(opportunisticCapacity)
            }
            if let totalCapacity = values.volumeTotalCapacity {
                total = capacity(totalCapacity)
            }
        } catch {
            print("Error retrieving capacity: \(error.localizedDescription)")
        }
    }
}
