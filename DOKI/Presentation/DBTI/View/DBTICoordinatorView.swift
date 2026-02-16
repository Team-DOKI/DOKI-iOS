//
//  DBTICoordinatorView.swift
//  DOKI
//
//  Created by 안치욱 on 2/15/26.
//

import SwiftUI

struct DBTICoordinatorView: View {

    @StateObject var coordinator: Coordinator<DBTIRoute>
    @StateObject var viewModel: DBTIViewModel

    init(
        context: DBTIEntryContext,
        coordinator: Coordinator<DBTIRoute> = Coordinator<DBTIRoute>(),
        questions: [DBTIQuestion]? = nil
    ) {
        self._coordinator = StateObject(wrappedValue: coordinator)
        self._viewModel = StateObject(
            wrappedValue: DBTIViewModel(context: context, questions: questions ?? DBTIDummyLoader.loadSurveyQuestions())
        )
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            DBTISurveyView(viewModel: viewModel)
                .navigationDestination(for: DBTIRoute.self) { route in
                    switch route {
                    case .result(let context):
                        let resultViewModel = DBTIResultViewModel(context: context)

                        DBTIResultView(viewModel: resultViewModel)
                            .onAppear {
                                resultViewModel.fetch()
                                bindResultAction(resultViewModel)
                            }
                    }
                }
        }
        .onAppear(perform: bindAction)
    }

    private func bindAction() {
        viewModel.navigationAction = { route in
            coordinator.push(route)
        }
    }

    private func bindResultAction(_ resultViewModel: DBTIResultViewModel) {
        resultViewModel.action = { action in
            switch action {
            case .restart:
                coordinator.popToRoot()
                viewModel.resetAll()

            case .goHome:
                coordinator.popToRoot()
            }
        }
    }
}


enum DBTIDummyJSON {
    static let survey = """
    {
      "code": "S000",
      "message": "요청 처리 성공",
      "data": {
        "questions": [
          {
            "id": 101,
            "category": { "code": "EI", "name": "휴식가 vs 탐험가" },
            "content": "산책 나가면 우리 강아지는...",
            "options": [
              { "id": 1001, "content": "익숙한 코스에서 짧게 다녀오는게 좋아요", "imageUrl": "https://lgtm-images.lgtmeow.com/2022/09/14/11/151f27e7-f9fd-4093-8f87-cd95d9cdadb3.webp", "value": "I" },
              { "id": 1002, "content": "동네 구석구석 새 길을 탐험해야 신나요", "imageUrl": "https://lgtm-images.lgtmeow.com/2024/02/05/10/a51a92bd-fd94-44db-99bb-c2e130c77613.webp", "value": "E" }
            ]
          },
          {
            "id": 102,
            "category": { "code": "EI", "name": "휴식가 vs 탐험가" },
            "content": "하루 일과에서 강아지가 더 행복한 순간은?",
            "options": [
              { "id": 1003, "content": "집사 옆에서 편안히 누워 쉬고 있을 때", "imageUrl": "https://lgtm-images.lgtmeow.com/2025/06/10/12/1d57a249-5133-4788-b3d0-4433ccb0887a.webp", "value": "I" },
              { "id": 1004, "content": "뛰어놀며 밖에서 활발하게 움직일 때", "imageUrl": "https://lgtm-images.lgtmeow.com/2024/09/26/11/c4805315-3e25-4977-973c-4822e2852027.webp", "value": "E" }
            ]
          },
          {
            "id": 103,
            "category": { "code": "EI", "name": "휴식가 vs 탐험가" },
            "content": "산책 준비를 할 때 우리 강아지는...",
            "options": [
              { "id": 1005, "content": "나가기 전부터 차분히 기다리고 있어요", "imageUrl": "https://lgtm-images.lgtmeow.com/2024/02/10/23/2dcb3b6a-d244-4bb0-a978-92a6025dc392.webp", "value": "I" },
              { "id": 1006, "content": "목줄만 보면 이미 흥분해서 뛰어다녀요", "imageUrl": "https://lgtm-images.lgtmeow.com/2024/07/11/20/4ae32b94-3bcc-4809-9b19-0dedb5b62462.webp", "value": "E" }
            ]
          },

          {
            "id": 201,
            "category": { "code": "PS", "name": "부끄멍 vs 적극멍" },
            "content": "산책 중 다른 강아지를 만나면 우리 강아지는...",
            "options": [
              { "id": 2001, "content": "잠깐 눈치만 보고 거리를 유지해요", "imageUrl": "https://lgtm-images.lgtmeow.com/2022/09/14/11/151f27e7-f9fd-4093-8f87-cd95d9cdadb3.webp", "value": "S" },
              { "id": 2002, "content": "먼저 다가가서 인사하고 놀자고 해요", "imageUrl": "https://lgtm-images.lgtmeow.com/2024/02/05/10/a51a92bd-fd94-44db-99bb-c2e130c77613.webp", "value": "P" }
            ]
          },
          {
            "id": 202,
            "category": { "code": "PS", "name": "부끄멍 vs 적극멍" },
            "content": "산책 중 낯선 사람이 다가오면 우리 강아지는...",
            "options": [
              { "id": 2003, "content": "조용히 집사 뒤에 숨어요", "imageUrl": "https://lgtm-images.lgtmeow.com/2025/06/10/12/1d57a249-5133-4788-b3d0-4433ccb0887a.webp", "value": "S" },
              { "id": 2004, "content": "반갑게 꼬리 흔들며 인사해요", "imageUrl": "https://lgtm-images.lgtmeow.com/2024/09/26/11/c4805315-3e25-4977-973c-4822e2852027.webp", "value": "P" }
            ]
          },
          {
            "id": 203,
            "category": { "code": "PS", "name": "부끄멍 vs 적극멍" },
            "content": "집에 친구 강아지가 놀러오면 우리 강아지는...",
            "options": [
              { "id": 2005, "content": "자리와 장난감을 지키며 조용히 지켜봐요", "imageUrl": "https://lgtm-images.lgtmeow.com/2024/02/10/23/2dcb3b6a-d244-4bb0-a978-92a6025dc392.webp", "value": "S" },
              { "id": 2006, "content": "같이 놀자며 장난감을 물어와요", "imageUrl": "https://lgtm-images.lgtmeow.com/2024/07/11/20/4ae32b94-3bcc-4809-9b19-0dedb5b62462.webp", "value": "P" }
            ]
          },

          {
            "id": 301,
            "category": { "code": "RF", "name": "루틴러 vs 자유러" },
            "content": "산책 시간에 대해 우리 강아지는...",
            "options": [
              { "id": 3001, "content": "매일 비슷한 시간대가 좋아요", "imageUrl": "https://lgtm-images.lgtmeow.com/2022/09/14/11/151f27e7-f9fd-4093-8f87-cd95d9cdadb3.webp", "value": "R" },
              { "id": 3002, "content": "언제든지 즉흥적으로 나가도 신나요", "imageUrl": "https://lgtm-images.lgtmeow.com/2024/02/05/10/a51a92bd-fd94-44db-99bb-c2e130c77613.webp", "value": "F" }
            ]
          },
          {
            "id": 302,
            "category": { "code": "RF", "name": "루틴러 vs 자유러" },
            "content": "산책 코스에 대해 우리 강아지는...",
            "options": [
              { "id": 3003, "content": "늘 가던 코스로 산책해야 안정돼요", "imageUrl": "https://lgtm-images.lgtmeow.com/2025/06/10/12/1d57a249-5133-4788-b3d0-4433ccb0887a.webp", "value": "R" },
              { "id": 3004, "content": "매번 다른 코스를 시도하는게 즐거워요", "imageUrl": "https://lgtm-images.lgtmeow.com/2024/09/26/11/c4805315-3e25-4977-973c-4822e2852027.webp", "value": "F" }
            ]
          },
          {
            "id": 303,
            "category": { "code": "RF", "name": "루틴러 vs 자유러" },
            "content": "하루 일과에서 우리 강아지는...",
            "options": [
              { "id": 3005, "content": "일정하게 밥·산책 패턴이 맞춰져야 해요", "imageUrl": "https://lgtm-images.lgtmeow.com/2024/02/10/23/2dcb3b6a-d244-4bb0-a978-92a6025dc392.webp", "value": "R" },
              { "id": 3006, "content": "상황따라 자유롭게 달라져도 괜찮아요", "imageUrl": "https://lgtm-images.lgtmeow.com/2024/07/11/20/4ae32b94-3bcc-4809-9b19-0dedb5b62462.webp", "value": "F" }
            ]
          }
        ]
      }
    }
    """

    static let result = """
    {
      "code": "S000",
      "message": "요청 성공",
      "data": {
        "type": "ISF",
        "name": "온순한 방구석멍",
        "image": "https://lgtm-images.lgtmeow.com/2024/06/26/10/c72d9db3-8e22-4f28-b76a-366a937efd52.webp",
        "keyword": ["차분", "다소 활발", "탐험"],
        "description": "내향적이고 온순하며 자유로운 흐름 속에서 소소한 행복을 찾습니다.",
        "analysis": [
          { "axis": "EI", "leftLabel": "휴식가", "rightLabel": "탐험가", "dominantSide": "right", "score": 2 },
          { "axis": "PS", "leftLabel": "부끄멍", "rightLabel": "적극멍", "dominantSide": "left", "score": 3 },
          { "axis": "RT", "leftLabel": "루틴러", "rightLabel": "자유러", "dominantSide": "right", "score": 2 }
        ]
      }
    }
    """
}

enum DBTIDummyLoader {
    static func loadSurveyQuestions() -> [DBTIQuestion] {
        let data = Data(DBTIDummyJSON.survey.utf8)
        let decoded = try! JSONDecoder().decode(BaseDTO<DBTISurveyResponseDTO>.self, from: data)
        guard let dataDTO = decoded.data else {
            assertionFailure("DBTIDummyLoader: decoded.data is nil")
            return []
        }
        return dataDTO.questions.map { $0.toDomain() }
    }
}

enum DBTIResultDummyLoader {
    static func loadResult() -> DBTIResult {
        let data = Data(DBTIDummyJSON.result.utf8)
        let decoded = try! JSONDecoder().decode(BaseDTO<DBTIResultDTO>.self, from: data)
        guard let dataDTO = decoded.data else {
            assertionFailure("DBTIResultDummyLoader: decoded.data is nil")
            return DBTIResult(
                type: "",
                name: "",
                imageURL: nil,
                keywords: [],
                description: "",
                analysis: []
            )
        }
        return dataDTO.toDomain()
    }
}
