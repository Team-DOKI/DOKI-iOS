//
//  FollowRouteReviewView.swift
//  DOKI
//
//  Created by 이세민 on 3/13/26.
//

import SwiftUI
import Kingfisher

struct FollowRouteReviewView: View {
    @StateObject var viewModel: FollowRouteReviewViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                Spacer().frame(height: 24)

                routeHeaderSection

                Spacer().frame(height: 16)

                walkInfoSection

                Spacer().frame(height: 40)

                congestionSection

                Spacer().frame(height: 40)

                dogInteractionSection

                Spacer().frame(height: 40)

                safetySection

                Spacer().frame(height: 40)

                convenienceSection

                Spacer().frame(height: 40)

                environmentSection

                Spacer().frame(height: 40)

                buttonSection

                Spacer().frame(height: 30)
            }
            .padding(.horizontal, 16)
        }
        .onTapGesture {
            UIApplication.shared.hideKeyboard()
        }
        .overlay(alignment: .top) {
            Rectangle()
                .frame(height: 2)
                .foregroundStyle(.defaultButton)
        }
        .topNavigationView(center: {
            Text("산책 후기 남기기")
                .subtitle()
        })
        .ignoresSafeArea(.container, edges: .bottom)
        .navigationBarBackButtonHidden(true)
        .task {
            await viewModel.fetchReviewHeader()
            await viewModel.fetchFilterCategories()
        }
        .customAlert(
            isPresented: $viewModel.isShowCompleteAlert,
            image: Image(.imgFoot),
            message: "후기가 등록이 완료되었어요!",
            subMessage: "덕분에 DOKI가 보호자님을 더 잘 알게 됐어요.\n이 정보로 다음엔 더 완벽한 경로를 추천해 드릴게요.",
            primaryTitle: "확인",
            primaryAction: { viewModel.dismissAfterAlert() }
        )
    }
}

extension FollowRouteReviewView {
    // 루트 제목 + 내 강아지 프로필
    private var routeHeaderSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(viewModel.routeTitle)
                .header3()
                .padding(.vertical, 16)

            HStack(spacing: 10) {
                KFImage(URL(string: viewModel.petProfileImageURL))
                    .placeholder { Color.gray.opacity(0.3) }
                    .resizable()
                    .scaledToFill()
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())

                Text(viewModel.petName)
                    .subtitle(color: .defaultDark)
            }
            .padding(.vertical, 12)
        }
        .redacted(reason: viewModel.loadingStatus == .loading ? .placeholder : [])
    }

    // 주소 / 날짜 / 거리·시간·걸음수
    private var walkInfoSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Label(title: { Text(viewModel.address) }, icon: { Image(.icMarker) })
                .font(.bodyActive)
                .foregroundStyle(.defaultDark)

            Label(title: { Text(viewModel.recordDate) }, icon: { Image(.icTimeclock) })
                .font(.bodyActive)
                .foregroundStyle(.defaultDark)

            Label(title: { Text(viewModel.walkRecord) }, icon: { Image(.icWalkinfo) })
                .font(.bodyActive)
                .foregroundStyle(.defaultDark)
        }
    }

    // 혼잡도
    private var congestionSection: some View {
        VStack(spacing: 16) {
            SectionHeader(title: "혼잡도", subtitle: "(필수 선택)")
            SegmentedButton(
                items: viewModel.congestion,
                selectedItem: $viewModel.selectedCongestion
            )
        }
    }

    // 강아지 교류 빈도
    private var dogInteractionSection: some View {
        VStack(spacing: 16) {
            SectionHeader(title: "강아지 교류 빈도", subtitle: "(필수 선택)")
            SegmentedButton(
                items: viewModel.exchange,
                selectedItem: $viewModel.selectedExchange
            )
        }
    }

    // 안전
    private var safetySection: some View {
        SelectableSection(
            title: "안전",
            subtitle: "(복수 선택 가능)",
            items: $viewModel.safety
        )
    }

    // 편의성
    private var convenienceSection: some View {
        SelectableSection(
            title: "편의성",
            subtitle: "(복수 선택 가능)",
            items: $viewModel.convenience
        )
    }

    // 환경
    private var environmentSection: some View {
        SelectableSection(
            title: "환경",
            subtitle: "(복수 선택 가능)",
            items: $viewModel.environment
        )
    }

    // 버튼
    private var buttonSection: some View {
        MainButton(
            text: "산책 후기 남기기",
            buttonState: viewModel.isFormValid ? .active1 : .disabled
        ) {
            viewModel.completeReview()
        }
    }
}
