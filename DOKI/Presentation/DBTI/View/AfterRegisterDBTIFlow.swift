//
//  AfterRegisterDBTIFlow.swift
//  DOKI
//
//  Created by 이세민 on 2/21/26.
//

import SwiftUI

struct AfterRegisterDBTIFlow: View {
    @StateObject private var dbtiViewModel = DBTIViewModel(entryContext: .afterRegister)
    
    @State private var path: [DBTIAction] = []
    
    let onFinish: () -> Void
    
    var body: some View {
        NavigationStack(path: $path) {
            DBTIStartView(viewModel: dbtiViewModel)
                .navigationDestination(for: DBTIAction.self) { action in
                    switch action {
                    case .dbtiSurvey:
                        DBTISurveyView(viewModel: dbtiViewModel)
                        
                    case .dbtiResult:
                        DBTIResultView(viewModel: dbtiViewModel)
                        
                    default:
                        EmptyView()
                    }
                }
        }
        .onAppear {
            bindAction()
        }
    }
    
    private func bindAction() {
        dbtiViewModel.navigationAction = { action in
            switch action {
            case .dbtiSurvey:
                path.append(.dbtiSurvey)
                
            case .dbtiResult:
                path.append(.dbtiResult)
                
            case .dbtiRestart:
                path.removeAll()
                path.append(.dbtiSurvey)
                
            case .dbtiFinish:
                onFinish()
                
            default:
                break
            }
        }
    }
}
