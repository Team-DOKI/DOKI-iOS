////
////  TabBar.swift
////  PAWKEY
////
////  Created by 이세민 on 7/2/25.
////
//
//import SwiftUI
//
//struct TabBar: View {
//    @EnvironmentObject var mainTabViewModel: MainTabViewModel
//    
//    private let tabBarWidth: CGFloat = 262
//    
//    var body: some View {
//        let buttonWidth = tabBarWidth / CGFloat(TabBarItem.allCases.count)
//        
//        ZStack(alignment: .leading) {
//            Circle()
//                .fill(Color.white)
//                .frame(width: 48, height: 48)
//                .offset(x: indicatorOffset(buttonWidth: buttonWidth))
//                .animation(.easeInOut(duration: 0.2), value: mainTabViewModel.selectedTab)
//            
//            HStack(spacing: 0) {
//                ForEach(TabBarItem.allCases, id: \.self) { item in
//                    Button(action: {
//                        mainTabViewModel.selectedTab = item
//                    }) {
//                        (mainTabViewModel.selectedTab == item ? item.selectedImage : item.normalImage)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 24, height: 24)
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 60)
//                    }
//                }
//            }
//        }
//        .frame(width: tabBarWidth, height: 60)
//        .background(Color.pawkeyBlack)
//        .cornerRadius(200)
//        .shadow(color: Color.pawkeyBlack.opacity(0.25), radius: 2, x: 0, y: 4)
//        .padding(.horizontal, 6)
//    }
//    
//    private func indicatorOffset(buttonWidth: CGFloat) -> CGFloat {
//        guard let index = TabBarItem.allCases.firstIndex(of: mainTabViewModel.selectedTab) else {
//            return 0
//        }
//        
//        let centerOffset = (buttonWidth - 48) / 2
//        return CGFloat(index) * buttonWidth + centerOffset
//    }
//}
