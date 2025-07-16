//
//  MyPageView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI

import Kingfisher

struct MyPageView: View {
    @EnvironmentObject var coordinator: Coordinator<MyPageScene>
    @EnvironmentObject var mainTabViewModel: MainTabViewModel

    @StateObject private var petProfileViewModel = PetProfileViewModel()
    @StateObject private var userProfileViewModel = UserProfileViewModel()
    @StateObject var viewModel: MyPageViewModel

    
    init(viewModel: MyPageViewModel = MyPageViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            // 제목
            VStack(spacing: 16) {
                HStack {
                    Text("마이페이지")
                        .font(.head_20_b)
                        .padding(.top, 20)
                        .padding(.leading, 16)
                    Spacer()
                }
                .padding(.bottom, 6)
                
                // 견주 프로필
                HStack {
                    HStack {
                        if let user = userProfileViewModel.userProfile {
                            Text( user.name + " 님")
                                .font(.head_18_sb)
                                .foregroundColor(.pawkeyBlack)
                        }
                        Text("견주")
                            .font(.caption_12_m)
                            .foregroundColor(.gray400)
                    }
                    .padding(.leading, 16)
                    .padding(.vertical, 24)
                    
                    Spacer()
                    
                    Button {
                        coordinator.push(.userProfile)
                        mainTabViewModel.isHidden = true
                    } label: {
                        Image(.arrowRightGray)
                    }
                    .padding(.vertical, 24)
                    .padding(.trailing, 13)
                }
                .background(Color.pawkeyWhite1)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .padding(.horizontal, 16)
                
                // 반려견 프로필
                if let pet = petProfileViewModel.petProfile {
                    VStack(spacing: 0) {
                        let petGender = pet.gender == "M" ? "남아" : "여아"
                        HStack {
                            Image(.idCard)
                            Text("반려견 프로필")
                                .font(.body_16_sb)
                                .foregroundColor(.pawkeyWhite1)
                            Spacer()
                            Button {
                                coordinator.push(.petProfile)
                                mainTabViewModel.isHidden = true
                            } label: {
                                Image(.arrowRightWhite)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                        .background(Color.green500)
                        
                        VStack {
                            VStack {
                                HStack {
                                    KFImage(URL(string: pet.imageURL))
                                        .placeholder {
                                            Image(.profile)
                                                .resizable()
                                        }
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 60, height: 60)
                                        .clipShape(Circle())
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(pet.name)
                                            .font(.head_18_sb)
                                        Text("\(pet.age)세 · " + petGender)
                                            .font(.caption_12_r)
                                            .foregroundColor(.gray300)
                                    }
                                    .padding(.leading, 8)
                                    
                                    Spacer()
                                }
                                .padding(.top, 16)
                                
                                HStack(spacing: 8) {
                                    Chip(title: "#조금느긋해요", isActive: false, textColor: .gray400)
                                    Chip(title: "#오토바이소리", isActive: false, textColor: .gray400)
                                    Chip(title: "#대형견", isActive: false, textColor: .gray400)
                                    Spacer()
                                }
                                .padding(.top, 16)
                            }
                            .padding(.leading, 16)
                            
                            HStack {
                                VStack(alignment: .center, spacing: 8) {
                                    Text("산책 횟수")
                                        .font(.caption_12_r)
                                    Text("\(pet.walkCount)회")
                                        .font(.head_20_b)
                                        .foregroundStyle(Color.green500)
                                }
                                .frame(maxWidth: .infinity)
                                
                                Divider()
                                    .foregroundStyle(Color.gray100)
                                    .frame(height: 38)
                                
                                VStack(alignment: .center, spacing: 8) {
                                    Text("누적 거리")
                                        .font(.caption_12_r)
                                    Text("14km")
                                        .font(.head_20_b)
                                        .foregroundStyle(Color.green500)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .padding(.horizontal, 15)
                            .padding(.vertical, 20)
                        }
                    }
                    .background(Color.pawkeyWhite1)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .padding(.horizontal, 16)
                }
                
                // 산책관리
                VStack(alignment: .leading, spacing: 0) {
                    
                    HStack {
                        Text("산책 루트 관리")
                            .font(.caption_12_sb)
                            .foregroundColor(.gray400)
                            .padding(.top, 16)
                            .padding(.leading, 16)
                        Spacer()
                    }
                    
                    // 저장한 산책 루트
                    HStack {
                        HStack(spacing: 12) {
                            Image(.heartIconBlack)
                            Text("저장한 산책 루트")
                                .font(.body_16_sb)
                        }
                        
                        Spacer()
                        
                        Image(.arrowRightBlack20)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        coordinator.push(.savedCourse)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)
                    
                    Divider()
                        .padding(.horizontal, 16)
                        .foregroundStyle(Color.gray50)
                    
                    // 내가 기록한 산책 루트
                    HStack {
                        HStack(spacing: 12) {
                            Image(.editIconBlack)
                            Text("내가 기록한 산책 루트")
                                .font(.body_16_sb)
                        }
                        
                        Spacer()
                        
                        Image(.arrowRightBlack20)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        coordinator.push(.myCourse)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)
                    
                    Divider()
                        .padding(.horizontal, 16)
                        .foregroundStyle(Color.gray50)
                }
                .background(Color.white)
                
                Spacer()
                
            }
        }
        .background(Color.pawkeyWhite2)
        .onAppear {
            petProfileViewModel.fetchPetProfile()
            Task {
                await userProfileViewModel.fetchUserProfile()
            }
        }
    }
}
