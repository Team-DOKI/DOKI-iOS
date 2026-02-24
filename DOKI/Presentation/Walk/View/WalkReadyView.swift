//
//  WalkReadyView.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

struct WalkReadyView: View {
    @StateObject var viewModel: WalkReadyViewModel
    
    @State private var items: [WalkItem] = []
    
    @State private var isAddingItem: Bool = false
    @State private var newItemText: String = ""
    @State private var itemListHeight: CGFloat = 0
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                HStack(spacing: 18) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("오늘의 산책 TIP")
                            .font(.small)
                            .foregroundStyle(.defaultMiddle)
                        
                        Text(viewModel.mainMessage)
                            .font(.subtitle)
                            .foregroundColor(.contents)
                        
                        Text(viewModel.subMessage)
                            .font(.bodySmall)
                            .foregroundColor(.contents)
                    }
                    .padding(.vertical, 16)
                    
                    Spacer()
                    
                    Image(.imgUpperbodydog)
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
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("산책 필수템")
                        .font(.subtitle)
                        .foregroundColor(.defaultDark)
                    
                    ScrollView(showsIndicators: false) {
                        itemList
                    }
                    .frame(maxHeight: itemListHeight == 0 ? .infinity : itemListHeight)
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .preference(key: HeightKey.self, value: geo.size.height)
                        }
                    )
                    .onPreferenceChange(HeightKey.self) { height in
                        if itemListHeight == 0 {
                            itemListHeight = height
                        }
                    }
                    
                    Button {
                        isAddingItem = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            isTextFieldFocused = true
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
            }
        }
        .onChange(of: viewModel.preparations) { _, newValue in
            items = newValue.map {
                WalkItem(name: $0, isChecked: false)
            }
        }
        .safeAreaInset(edge: .bottom) {
            MainButton(
                text: "산책 기록 시작하기",
                buttonState: .active2,
                action: {
                    viewModel.navigateToWalkRecord()
                }
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 85)
        }
        .ignoresSafeArea(.keyboard)
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
                    
                    Text(item.name)
                        .font(.subDefault)
                        .foregroundColor(item.isChecked ? .defaultDark : .defaultMiddle)
                    
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
            
            if isAddingItem {
                HStack(spacing: 8) {
                    Image(.btnUncheck)
                    
                    TextField("준비물을 작성해주세요", text: $newItemText)
                        .font(.subDefault)
                        .foregroundStyle(.defaultMiddle)
                        .focused($isTextFieldFocused)
                        .submitLabel(.done)
                        .onSubmit {
                            let trimmed = newItemText.trimmingCharacters(in: .whitespaces)
                            guard !trimmed.isEmpty else { return }
                            
                            items.append(
                                WalkItem(name: trimmed, isChecked: false)
                            )
                            newItemText = ""
                            isAddingItem = false
                        }
                    
                    Spacer()
                    
                    Image(.btnX)
                        .opacity(0)
                }
                .padding(.vertical, 8)
                
                Divider()
                    .background(.defaultBright)
            }
        }
    }
}

private struct HeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
