//
//  DBTIResultViewModel.swift
//  DOKI
//
//  Created by 안치욱 on 2/14/26.
//

import Foundation

enum DBTIResultAction {
    case restart
    case goHome
}

@MainActor
final class DBTIResultViewModel: ObservableObject {
    var action: ((DBTIResultAction) -> Void)?

    let context: DBTIEntryContext
    @Published private(set) var result: DBTIResult

    init(context: DBTIEntryContext, initialResult: DBTIResult = DBTIResultDummyLoader.loadResult()) {
        self.context = context
        self.result = initialResult
    }

    var showsHomeButton: Bool { context == .register }

    func fetch() {
        Task {
            try? await Task.sleep(nanoseconds: 250_000_000)
            self.result = DBTIResultDummyLoader.loadResult()
        }
    }

    func restartTapped() { action?(.restart) }
    func homeTapped() { action?(.goHome) }
}
