//
//  PetProfileView.swift
//  PAWKEY
//
//  Created by 이세민, Edited by 안치욱 on 7/7/25.
//

import SwiftUI

import Kingfisher

struct PetProfileView: View {
    @EnvironmentObject var router: Coordinator<MyPageScreen>
    @EnvironmentObject var tabBarState: TabBarState
    @StateObject private var viewModel = PetProfileViewModel()
    
    var body: some View {
        VStack(spacing: 8) {
            if let pet = viewModel.petProfile {
                KFImage(URL(string: pet.imageURL))
                    .placeholder {
                        Image(.profile)
                            .resizable()
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 108, height: 108)
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(Color.green500, lineWidth: 2)
                    }
                    .padding(.vertical, 36)
                
                VStack(alignment: .leading, spacing: 16) {
                    // 이름
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("이름")
                                .font(.body_14_m)
                                .padding(.leading, 16)
                            Spacer()
                        }
                        HStack {
                            Text(pet.name)
                                .font(.head_18_sb)
                                .foregroundStyle(Color.green500)
                                .padding(.leading, 16)
                        }
                    }
                    
                    // 성별
                    VStack(alignment: .leading, spacing: 10) {
                        Text("성별")
                            .font(.body_14_m)
                            .padding(.leading, 16)
                        if(pet.gender == "M") {
                            Text("남아")
                            .font(.head_18_sb)
                            .foregroundStyle(Color.green500)
                            .padding(.leading, 16)
                        }
                        else {
                            Text("여아")
                            .font(.head_18_sb)
                            .foregroundStyle(Color.green500)
                            .padding(.leading, 16)
                        }
                    }
                    
                    // 중성화
                    if(pet.isNeutered) {
                        Text("중성화했어요")
                            .font(.caption_12_sb)
                            .foregroundStyle(Color.gray300)
                            .padding(.leading, 16)
                    }
                    else {
                        Text("중성화하지 않았어요")
                            .font(.caption2)
                            .foregroundStyle(Color.gray)
                            .padding(.leading, 16)
                    }
                    
                    // 견종
                    VStack(alignment: .leading, spacing: 10) {
                        Text("견종")
                            .font(.body_14_m)
                            .padding(.leading, 16)
                        Text(pet.breed)
                            .font(.head_18_sb)
                            .foregroundStyle(Color.green500)
                            .padding(.leading, 16)
                    }
                    
                    // 나이
                    VStack(alignment: .leading, spacing: 10) {
                        Text("나이")
                            .font(.body_14_m)
                            .padding(.leading, 16)
                        Text("\(pet.age)세")
                            .font(.head_18_sb)
                            .foregroundStyle(Color.green500)
                            .padding(.leading, 16)
                    }
                    
                    // 성향
                    VStack(alignment: .leading, spacing: 10) {
                        Text("성향")
                            .font(.body_14_m)
                            .padding(.leading, 16)
                        HStack {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("에너지 레벨")
                                    .font(.body_14_sb)
                                    .foregroundStyle(Color.gray400)
                                Text(pet.traits.first(where: { $0.category == "에너지레벨" })?.option ?? "")
                                    .font(.head_18_sb)
                                    .foregroundStyle(Color.green500)
                            }
                            .padding(.leading, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("사회성 레벨")
                                    .font(.body_14_sb)
                                    .foregroundStyle(Color.gray400)
                                Text(pet.traits.first(where: { $0.category == "사회성레벨" })?.option ?? "")
                                    .font(.head_18_sb)
                                    .foregroundStyle(Color.green500)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden()
        .topNavigationView {
            BackButton {
                router.pop()
                tabBarState.isHidden = false
            }
        } center: {
            Text("반려견 프로필")
                .font(.body_16_sb)
        }
        .onAppear {
            viewModel.fetchPetProfile()
        }
        
        
    }
}

