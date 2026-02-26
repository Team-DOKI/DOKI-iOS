//
//  DBTIViewModel.swift
//  DOKI
//
//  Created by 안치욱 on 2/12/26.
//

import Foundation

final class DBTIViewModel: ObservableObject {
    private let dbtiAPIService: DBTIAPIServiceProtocol
    let entryContext: DBTIEntryContext
    
    init(
        entryContext: DBTIEntryContext,
        dbtiAPIService: DBTIAPIServiceProtocol = DBTIAPIService()
    ) {
        self.entryContext = entryContext
        self.dbtiAPIService = dbtiAPIService
        
        fetchDBTIQuestions()
    }
    
    //MARK: - Survey
    
    @Published var questions: [DBTIQuestionData] = []
    
    //MARK: - Result
    
    @Published var dbtiName: String = "자유로운 꼬리바람"
    @Published var type: String = "EPF"
    @Published var resultImageUrl: String?
    @Published var keywords: [String] = ["자유", "즉흥", "활발"]
    @Published var description: String =
    "즉흥적이고 변화를 좋아해요.\n친구들과 매일 산책 코스를 즐기는 자유로운 영혼!"
    @Published var analysis: [AxisAnalysisData] = [
        .init(
            leftLabel: "휴식가",
            rightLabel: "탐험가",
            dominantSide: "right",
            score: 2
        ),
        .init(
            leftLabel: "부끄멍",
            rightLabel: "적극멍",
            dominantSide: "left",
            score: 1
        ),
        .init(
            leftLabel: "루틴러",
            rightLabel: "자유러",
            dominantSide: "right",
            score: 3
        )
    ]
    
    // MARK: - Step
    
    var navigationAction: ((DBTIAction) -> Void)?
    
    @Published var currentStep: Int = 0
    @Published var selectedIndex: Int? = nil
    
    var currentQuestion: DBTIQuestionData? {
        guard currentStep < questions.count else { return nil }
        return questions[currentStep]
    }
    
    var isFirstStep: Bool { currentStep == 0 }
    
    var isLastStep: Bool { currentStep == questions.count - 1 }
    
    var progress: Double {
        guard !questions.isEmpty else { return 0 }
        return Double(currentStep + 1) / Double(questions.count)
    }
    
    var buttonDisabled: Bool {
        selectedIndex == nil
    }
    
    // MARK: - Actions
    
    func goToNextStep() {
        guard selectedIndex != nil else { return }
        
        if isLastStep {
            navigationAction?(.dbtiResult)
        } else {
            currentStep += 1
            selectedIndex = nil
        }
    }
    
    func goToPrevStep() {
        guard !isFirstStep else { return }
        currentStep -= 1
        selectedIndex = nil
    }
    
    func restartSurvey() {
        currentStep = 0
        selectedIndex = nil
        navigationAction?(.dbtiRestart)
    }
    
    func finish() {
        navigationAction?(.dbtiFinish)
    }
}

// MARK: - API

extension DBTIViewModel {
    /// DBTI 질문 조회
    func fetchDBTIQuestions() {
        dbtiAPIService.fetchDBTIQuestions { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.questions = response?.data?.questions.map { q in
                        DBTIQuestionData(
                            title: q.category.name,
                            question: q.content,
                            options: q.options.map {
                                DBTIOptionData(
                                    content: $0.content,
                                    imageUrl: $0.imageUrl
                                )
                            }
                        )
                    } ?? []
                default:
                    print("DBTI 질문 조회 실패")
                }
            }
        }
    }
}
