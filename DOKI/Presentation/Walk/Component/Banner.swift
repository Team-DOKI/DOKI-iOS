//
//  Banner.swift
//  DOKI
//
//  Created by a on 11/2/25.
//

import SwiftUI

struct Banner: View {
    let imageName: [String]
    
    @State private var currentStep = 0
    
    var body: some View {
        TabView(selection: $currentStep) {
            ForEach(Array(imageName.enumerated()), id: \.offset) { index, imageName in
                Image(imageName)
                    .resizable()
                    .frame(height: 141)
                    .background(.defaultMiddle)
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(height: 141)
        .overlay(alignment: .bottom) {
            HStack(spacing: 4) {
                ForEach(Array(imageName.enumerated()), id: \.offset) { index, _ in
                    Rectangle()
                        .frame(width: currentStep == index ? 16 : 8, height: 8)
                        .cornerRadius(8)
                        .foregroundStyle(currentStep == index ? .defaultPrimary : .defaultButton)
                        .animation(.default, value: currentStep)
                }
            }
            .padding(.bottom, 8)
        }
    }
}
