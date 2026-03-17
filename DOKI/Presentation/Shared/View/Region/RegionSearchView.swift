//
//  RegionSearchView.swift
//  DOKI
//
//  Created by a on 10/31/25.
//

import SwiftUI

struct RegionSearchView: View {
    let regions: [DistrictDTOs]
    let selectedGuId: Int?
    let selectedDongId: Int?

    let onSelectGu: (Int) -> Void
    let onSelectDong: (Int) -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Text("산책 지역")
                .subtitle()
                .padding(.vertical, 25)
            
            HStack(spacing: 0) {
                ScrollView {
                    LazyVStack {
                        ForEach(regions, id: \.gu.id) { district in
                            OptionItem(
                                text: district.gu.name,
                                isChecked: district.gu.id == selectedGuId
                            ) {
                                onSelectGu(district.gu.id)
                            }
                        }
                    }
                    .frame(maxWidth: 80)
                }
                
                Divider().frame(maxWidth: 1, maxHeight: .infinity)
                
                ScrollView {
                    LazyVStack {
                        ForEach(regions.first { $0.gu.id == selectedGuId }?.dongs ?? [], id: \.id) { dong in
                            OptionItem(
                                text: dong.name,
                                isChecked: dong.id == selectedDongId
                            ) {
                                onSelectDong(dong.id)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}
