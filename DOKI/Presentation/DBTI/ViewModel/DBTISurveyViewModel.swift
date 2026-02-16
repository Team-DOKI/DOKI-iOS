//
//  DBTISurveyViewModel.swift
//  DOKI
//
//  Created by 안치욱 on 2/12/26.
//

import Foundation

enum DBTIEntryContext: Hashable {
    case register
    case myPage
}

enum DBTIRoute: Route {
    case result(DBTIEntryContext)
}

@MainActor
final class DBTIViewModel: ObservableObject {
    var navigationAction: ((DBTIRoute) -> Void)?

    private let context: DBTIEntryContext
    let questions: [DBTIQuestion]

    @Published var currentIndex: Int = 0
    @Published var isSubmitting: Bool = false

    @Published private(set) var selectedOptionByQuestion: [Int: Int] = [:]

    init(context: DBTIEntryContext, questions: [DBTIQuestion]) {
        self.context = context
        self.questions = questions
    }

    var currentQuestion: DBTIQuestion { questions[currentIndex] }

    var isFirstStep: Bool { currentIndex == 0 }
    var isLastStep: Bool { currentIndex == questions.count - 1 }

    var selectedOptionIDForCurrent: Int? {
        selectedOptionByQuestion[currentQuestion.id]
    }

    var buttonDisabled: Bool {
        selectedOptionIDForCurrent == nil
    }

    var progress: Double {
        Double(currentIndex + 1) / Double(questions.count)
    }

    func optionTapped(optionId: Int) {
        selectedOptionByQuestion[currentQuestion.id] = optionId
    }

    func goToNextStep() {
        guard !buttonDisabled else { return }
        guard !isLastStep else { return }
        currentIndex += 1
    }

    func goToPrevStep() {
        guard !isFirstStep else { return }
        currentIndex -= 1
    }

    func complete() {
        guard makeSubmitPayload() != nil else { return }
        
        isSubmitting = true
        
        Task {
            try? await Task.sleep(nanoseconds: 250_000_000)
            
            isSubmitting = false
            navigationAction?(.result(context))
        }
    }

    func makeSubmitPayload() -> DBTISubmitPayload? {

        guard selectedOptionByQuestion.count == questions.count else { return nil }

        var grouped: [String: [Int]] = [:]
        for q in questions {
            guard let optionId = selectedOptionByQuestion[q.id] else { return nil }
            grouped[q.categoryCode, default: []].append(optionId)
        }

        guard grouped["EI"]?.count == 3,
              grouped["PS"]?.count == 3,
              grouped["RF"]?.count == 3 else {
            return nil
        }

        return DBTISubmitPayload(
            eiOptionIds: grouped["EI"] ?? [],
            psOptionIds: grouped["PS"] ?? [],
            rtOptionIds: grouped["RF"] ?? []
        )
    }

    func resetAll() {
        currentIndex = 0
        selectedOptionByQuestion = [:]
    }
}
