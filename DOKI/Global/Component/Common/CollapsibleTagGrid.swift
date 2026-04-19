//
//  CollapsibleTagGrid.swift
//  DOKI
//
//  Created by 이세민 on 4/19/26.
//

import SwiftUI

/// 태그들을 실제 너비 기반으로 row를 계산해서,
/// 첫 번째 row만 보여주고 나머지가 있으면 확장 버튼을 표시하는 컴포넌트.
/// 개수가 아니라 실제 줄 넘침 여부로 판단.
struct CollapsibleTagGrid<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {
    let availableWidth: CGFloat
    let data: Data
    let spacing: CGFloat
    let content: (Data.Element) -> Content

    @State private var elementsSize: [Data.Element: CGSize] = [:]
    @State private var isExpanded: Bool = false

    private var allElements: [Data.Element] { Array(data) }

    private var rows: [[Data.Element]] {
        var result: [[Data.Element]] = [[]]
        var currentRow = 0
        var remaining = availableWidth

        for element in allElements {
            let size = elementsSize[element, default: CGSize(width: availableWidth, height: 1)]

            if remaining - (size.width + spacing) >= 0 {
                result[currentRow].append(element)
            } else {
                currentRow += 1
                result.append([element])
                remaining = availableWidth
            }
            remaining -= (size.width + spacing)
        }
        return result
    }

    var body: some View {
        let rows = self.rows
        let hasOverflow = rows.count > 1
        let displayRows = isExpanded ? rows : Array(rows.prefix(1))
        let hiddenCount = allElements.count - (rows.first?.count ?? 0)

        VStack(alignment: .leading, spacing: spacing) {
            ForEach(Array(displayRows.enumerated()), id: \.offset) { _, rowElements in
                HStack(spacing: spacing) {
                    ForEach(rowElements, id: \.self) { element in
                        content(element).fixedSize()
                    }
                }
            }

            if !isExpanded && hasOverflow {
                Spacer().frame(height: 11)

                HStack(spacing: 5) {
                    Rectangle()
                        .frame(height: 1.5)
                        .foregroundStyle(.defaultButton)

                    Text("+\(hiddenCount)")
                        .bodySmall(color: .defaultMiddle)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 4)
                        .background(.defaultButton)
                        .clipShape(Capsule())
                        .onTapGesture { isExpanded = true }

                    Rectangle()
                        .frame(height: 1.5)
                        .foregroundStyle(.defaultButton)
                }
            }
        }
        // 보이지 않는 측정 레이어: 모든 태그를 항상 렌더링해서 실제 너비를 측정.
        // collapsed 상태에서도 2번째 row 이후 태그들의 사이즈를 알아야 하므로 분리 필요.
        .background(
            ZStack(alignment: .topLeading) {
                ForEach(allElements, id: \.self) { element in
                    content(element)
                        .fixedSize()
                        .readSize { size in
                            elementsSize[element] = size
                        }
                }
            }
            .opacity(0)
            .allowsHitTesting(false)
        )
    }
}
