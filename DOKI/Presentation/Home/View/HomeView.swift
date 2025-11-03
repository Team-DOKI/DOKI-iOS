//
//  HomeView.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @State var item = "text1"
    @State var value:CGFloat = 0
    
    var body: some View {
        VStack {
            Text("item: \(item)")
            SegmentedButton(items: ["text1", "text2", "text3"], selectedItem: $item)
            Text("value: \(value)")
            RangeSlider(start: 10, end: 60, value: $value)
            HStack {
                WalkCourseCell()
                WalkCourseCell()
            }
            Banner(imageName: ["logo", "mapView"])
        }
        .padding()
    }
}
