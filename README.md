<img src ="https://github.com/user-attachments/assets/a83be8cb-5cf4-4309-99f6-c4b10ea23fd7"/>


# PAWKEY
> 반려동물과 보호자의 일상적인 산책을 더 다채롭고 즐거운 경험으로 바꿔주는 위치 기반 산책 큐레이션 플랫폼

<br/>


##  iOS Developers
| [이세민](https://github.com/sem-git) | [권석기](https://github.com/seokgit) | [안치욱](https://github.com/w0o0kgit) |
|:------------------------------------:|:-------------------------:|:------------------------------:|
| <img src="https://github.com/user-attachments/assets/ef82a7a7-7122-4bd9-9886-a537d4f0bb9c" alt="" width="250"/> | <img src="https://github.com/user-attachments/assets/a901dbe8-cee3-4093-a2d2-50d3e287b545" alt="" width="250"/> | <img src="https://github.com/user-attachments/assets/82ef8651-c1b3-45bd-a892-aa517dd72644" alt="" width="250"/> |
|`트래킹` `트래킹 기록` `루트 상세보기` <br> `공유 루트 산책` `후기 작성` <br> `산책 완료` `지역 관리` `온보딩`| `스플래시` `홈 대시보드` `회원가입/정보입력` <br> `로그인` `카테고리 필터링` `산책 기록 리스트`| `마이페이지` `유저/반려견 프로필` <br> `저장한 산책 루트` `내가 기록한 산책 루트` |

<br/>


## Tech Stack
**UI Framework**: SwiftUI, UIKit (optional)

**Architecture:** MVVM

**Xcode** : 16.4

<br/>


## Library

| Category | Name | Description | Version |
| --- | --- | --- | --- |
| **Map** | **MapKit** | Apple에서 제공하는 지도 표시 및 위치 기반 기능 구현용 프레임워크 |-|
| **Network** | **Moya** | 네트워크 요청을 추상화하여 코드 재사용성 및 테스트 용이성을 향상 | 15.0.3 |
| **Image** | **Kingfisher** | 이미지 비동기 다운로드 및 캐싱 처리 | 8.3.2 |
| **Animation** | **Lottie** | JSON 기반 벡터 애니메이션을 실시간으로 렌더링 | 4.5.2 |

<br/>


## Foldering
``` markdown
📂 PAWKEY
├── 📂 Application
│   └── 📄 PAWKEYApp
├── 📂 Global
│   ├── 📂 Component
│   ├── 📂 Coordinator
│   │   ├── 📂 HomeCoordinator
│   │   ├── 📂 MyPageCoordinator
│   │   ├── 📂 OnboardingCoordinator
│   │   └── 📂 WalkCoordinator
│   ├── 📂 Extension
│   ├── 📂 Manager
│   ├── 📂 Model
│   └── 📂 Modifier
├── 📂 Network
│   ├── 📂 Base
│   └── ...
├── 📂 Presentation
│   ├── 📂 ActivityArea
│   │   ├── 📂 Model
│   │   ├── 📂 View
│   │   └── 📂 ViewModel
│   └── ...
└── 📂 Resource
    ├── 📂 Font
    └── 📃 Assets.xcassets
```

<br/>

## Convention
| Type       | Description                                 | 
|------------|----------------------------------------------|
| `Feat`     | 새로운 UI 및 기능 구현                       |
| `Add`      | 부수적인 코드·폰트·에셋·주석 등 추가         |
| `Fix`      | 버그 및 오류 해결                            |
| `Refactor` | 리팩토링                                     |
| `Network`  | API 통신 연결                                |
| `Chore`    | 버전 코드, 패키지 구조, 의존성 추가          |
| `Docs`     | README, .gitignore 등의 문서 작업            |
| `Merge`    | 서로 다른 브랜치 간의 병합                   |

| Git           | Convention                          |
|----------------|----------------------------------|
| Commit Message | [Type] #이슈번호 작업내용 |
| Issue          |  [Type] ~ 구현        |
| PR             | [Type] #이슈번호 작업내용 |
| Branch         | type/#이슈번호          |

<br/>
