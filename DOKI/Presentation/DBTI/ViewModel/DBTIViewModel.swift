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
    @Published private var selectedOptionIds: [Int] = []
    
    //MARK: - Result
    
    @Published var dbtiName: String = ""
    @Published var type: String = ""
    @Published var resultImageUrl: String? = nil
    @Published var keywords: [String] = []
    @Published var description: String = ""
    @Published var analysis: [AxisAnalysisData] = []
    
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
    
    func goToNextStep(petId: Int) {
        guard let selectedIndex else { return }
        
        if selectedOptionIds.count != questions.count {
            selectedOptionIds = Array(repeating: 0, count: questions.count)
        }
        
        selectedOptionIds[currentStep] = questions[currentStep].options[selectedIndex].id
        
        if isLastStep {
            submitDBTI(petId: petId)
        } else {
            currentStep += 1
            self.selectedIndex = nil
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
        selectedOptionIds.removeAll()
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
                                    id: $0.id,
                                    content: $0.content,
                                    imageUrl: $0.imageUrl
                                )
                            }
                        )
                    } ?? []
                default:
                    print("DBTI 질문 조회에 실패했습니다.")
                }
            }
        }
    }
    
    /// DBTI 검사 제출
    func submitDBTI(petId: Int) {
        let request = DBTISurveyRequest(optionIds: selectedOptionIds)
        
        dbtiAPIService.submitDBTI(
            petId: petId,
            request: request
        ) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    guard let data = response?.data else { return }
                    
                    self.type = data.type
                    self.dbtiName = data.name
                    self.resultImageUrl = data.image
                    self.keywords = data.keyword
                    self.description = data.description
                    self.analysis = data.analysis.map {
                        AxisAnalysisData(
                            leftLabel: $0.leftLabel,
                            rightLabel: $0.rightLabel,
                            dominantSide: $0.dominantSide,
                            score: $0.score
                        )
                    }
                    
                    self.navigationAction?(.dbtiResult)
                    
                default:
                    print("DBTI 검사 제출에 실패했습니다.")
                }
            }
        }
    }
    
    /// DBTI 결과 조회
    func fetchDBTIResult(petId: Int) {
        dbtiAPIService.fetchDBTIResult(petId: petId) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    guard let data = response?.data else { return }
                    
                    self.dbtiName = data.name
                    self.type = data.type
                    self.resultImageUrl = data.image
                    self.keywords = data.keyword
                    self.description = data.description
                    self.analysis = data.analysis.map {
                        AxisAnalysisData(
                            leftLabel: $0.leftLabel,
                            rightLabel: $0.rightLabel,
                            dominantSide: $0.dominantSide,
                            score: $0.score
                        )
                    }
                    
                default:
                    print("DBTI 결과 조회에 실패했습니다.")
                }
            }
        }
    }
}
