//
//  PetProfileViewModel.swift
//  PAWKEY
//
//  Created by 안치욱 on 7/16/25.
//

import SwiftUI

import Moya

class PetProfileViewModel: ObservableObject {
    @Published var petProfile: PetProfile?

    private let provider = MoyaProvider<PetProfileAPI>()

    func fetchPetProfile() {
        provider.request(.getPetProfile) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let dto = try JSONDecoder().decode(PetProfileDTO.self, from: response.data)

                    if let firstDTO = dto.petProfileList.first {
                        self?.petProfile = PetProfile(dto: firstDTO)
                    } else {
                        print("반려견 리스트가 비어 있음")
                    }

                } catch {
                    print("디코딩 오류: \(error)")
                }
            case .failure(let error):
                print("네트워크 오류: \(error)")
            }
        }
    }
}
