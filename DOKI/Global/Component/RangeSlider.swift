//
//  RangeSlider.swift
//  DOKI
//
//  Created by a on 11/1/25.
//

import SwiftUI

struct RangeSlider: View {
    @State private var currentOffset = CGFloat.zero
    @State private var initialOffset = CGFloat.zero
    
    let start: CGFloat
    let end: CGFloat
    @Binding var value: Int
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                RoundedRectangle(cornerRadius: 50)
                    .frame(maxWidth: .infinity, maxHeight: 5)
                    .foregroundStyle(.defaultButton)
                    .overlay(
                        Rectangle()
                            .frame(maxWidth: .infinity, maxHeight: 5)
                            .offset(x: -geometry.size.width + currentOffset, y: 0)
                            .foregroundStyle(.defaultPrimary)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 50))
                    .overlay(
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.defaultPrimary)
                            .position(x: currentOffset, y: 2.5)
                            .gesture(dragGesture(geometry))
                    )
                    .onTapGesture(count:1, coordinateSpace: .global) { location in
                        currentOffset = min(max(0, location.x), geometry.size.width)
                        initialOffset = currentOffset
                        let percentage = currentOffset / geometry.size.width
                        value = Int(start + (end - start) * percentage)
                    }
                HStack {
                    Text("\(Int(start))")
                        .subDefault(color: .defaultMiddle)
                    Spacer()
                    Text("\(Int(end))")
                        .subDefault(color: .defaultMiddle)
                }
                .padding(.top, 3)
            }
        }
        .frame(height: 35)
    }
    
    func dragGesture(_ geometry: GeometryProxy) -> some Gesture {
        DragGesture()
            .onChanged { gesture in
                // drag 시작할떄 0으로 초기화 방지
                let newOffset = initialOffset + gesture.translation.width
                currentOffset = min(max(0, newOffset), geometry.size.width)
                let percentage = currentOffset / geometry.size.width
                value = Int(start + (end - start) * percentage)
            }
            .onEnded { _ in
                initialOffset = currentOffset
            }
    }
}

