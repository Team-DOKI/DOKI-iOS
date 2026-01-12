//
//  MyPageViewModel.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

class MyPageViewModel: ObservableObject {
    var navigationAction: ((MyPageRoute)->())?
        
    func navigateToPetProfile() {
        navigationAction?(.petProfile)
    }
    
    func navigateToMyProfile() {
        navigationAction?(.myProfile)
    }
    
    func navigateToWalkRecord() {
        navigationAction?(.walkRecord)
    }
    
    func navigateToSavedWalk() {
        navigationAction?(.savedWalk)
    }
    
    func navigateToReview() {
        navigationAction?(.review)
    }
    
    func navigateToActivityAreaSetting() {
        navigationAction?(.activityAreaSetting)
    }
    
    func navigateToAppInfo() {
        navigationAction?(.appInfo)
    }
}
