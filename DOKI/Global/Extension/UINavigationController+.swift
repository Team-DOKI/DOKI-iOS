//
//  UINavigationController+.swift
//  DOKI
//
//  Created by 이세민 on 4/19/26.
//

import UIKit

extension UINavigationController {
    /// navigationBarHidden(true) 상태에서도 스와이프 뒤로가기 제스처가 동작하도록 설정
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
