//
//  WalkView.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

struct WalkView: View {
    @StateObject var viewModel: WalkViewModel
    
    @State private var items: [WalkItem] = [
        WalkItem(name: "배변 봉투", isChecked: false, isEditing: false),
        WalkItem(name: "리드줄", isChecked: true, isEditing: false),
        WalkItem(name: "물", isChecked: true, isEditing: false),
        WalkItem(name: "간식", isChecked: false, isEditing: false)
    ]
    
    @FocusState private var focusedItemID: UUID?
    
    var isScrollable: Bool {
        items.count > 7
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - 오늘의 산책 TIP
            
            HStack(spacing: 18) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("오늘의 산책 TIP")
                        .font(.small)
                        .foregroundStyle(.defaultMiddle)
                    
                    Text("발이 차가워요.. 잠깐 다녀와요!")
                        .font(.subtitle)
                        .foregroundColor(.contents)
                    
                    Text("10분 내 짧은 산책 / 패딩과 신발 필수")
                        .font(.bodySmall)
                        .foregroundColor(.contents)
                }
                .padding(.vertical, 16)
                
                Image(.imgWalkdog)
                    .padding(.top, 8)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .background(.defaultBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.defaultPrimary, lineWidth: 1)
            )
            .padding(.top, 16)
            .padding(.horizontal, 15)
            
            // MARK: - 산책 필수템
            
            VStack(alignment: .leading, spacing: 16) {
                Text("산책 필수템")
                    .font(.subtitle)
                    .foregroundColor(.defaultDark)
                
                if isScrollable {
                    ScrollView {
                        itemList
                    }
                    .scrollIndicators(.hidden)
                } else {
                    itemList
                }
                
                Button {
                    let newItem = WalkItem(
                        name: "",
                        isChecked: false,
                        isEditing: true
                    )
                    
                    items.append(newItem)
                    
                    DispatchQueue.main.async {
                        focusedItemID = newItem.id
                    }
                } label: {
                    Text("+ 추가하기")
                        .font(.subActive)
                        .foregroundColor(.defaultPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(.primaryGra1)
                        .cornerRadius(8)
                }
            }
            .padding(16)
            .background(.defaultBackground)
            .cornerRadius(16)
            .padding(16)
            
            Spacer()
            
            // MARK: - 산책 기록 시작하기 버튼
            
            MainButton(text: "산책 기록 시작하기", buttonState: .active2) {
                viewModel.navigateToWalkRecord()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 85)
            .opacity(focusedItemID == nil ? 1 : 0)
        }
        .background(.defaultBright)
        .topNavigationView(center: {
            Text("산책")
                .subtitle()
        })
    }
    
    private var itemList: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach($items) { $item in
                HStack(spacing: 8) {
                    Button {
                        item.isChecked.toggle()
                    } label: {
                        Image(item.isChecked ? .btnCheck : .btnUncheck)
                    }
                    
                    if item.isEditing {
                        TextField("준비물을 작성해주세요.", text: $item.name)
                            .font(.subDefault)
                            .foregroundColor(.defaultMiddle)
                            .submitLabel(.done)
                            .focused($focusedItemID, equals: item.id)
                            .onSubmit {
                                item.isEditing = false
                                focusedItemID = nil
                            }
                    } else {
                        Text(item.name)
                            .font(.subDefault)
                            .foregroundColor(
                                item.isChecked ? .defaultDark : .defaultMiddle
                            )
                    }
                    
                    Spacer()
                    
                    Button {
                        items.removeAll { $0.id == item.id }
                    } label: {
                        Image(.btnX)
                    }
                }
                .padding(.vertical, 8)
                
                Divider()
                    .background(.defaultBright)
            }
        }
    }
}
