//
//  HomeViewModel.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    var navigationAction: ((WalkRecordRoute)->())?
    
    func navigateToWalkRecord() {
        navigationAction?(.walkRecord)
    }
}
