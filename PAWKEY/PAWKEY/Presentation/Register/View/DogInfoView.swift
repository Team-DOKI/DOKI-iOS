//
//  DogInfoView.swift
//  PAWKEY
//
//  Created by 권석기 on 7/9/25.
//

import SwiftUI
import PhotosUI

struct DogInfoView: View {
    @ObservedObject var viewModel: ProfileSetUpViewModel
    
    @State var profileImage: [UIImage] = []
    @State var selectedItems: [PhotosPickerItem] = []
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                
                Spacer().frame(height: 20)
                
                Text("견주님의 반려견이 궁금해요!")
                    .font(.head_24_sb)
                    .foregroundStyle(.pawkeyBlack)
                    .frame(alignment: .center)
                Spacer().frame(height: 32)
                HStack {
                    Spacer()
                    PhotosPicker(selection: $selectedItems,
                                 maxSelectionCount: 1,
                                 matching: .images) {
                        
                        if let profileImage = profileImage.last {
                            Image(uiImage: profileImage)
                                .resizable()
                                .frame(width: 108, height: 108)
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(.green500, lineWidth: 2))
                        } else {
                            Circle()
                                .frame(width: 108, height: 108)
                                .foregroundStyle(.pawkeyWhite2)
                                .overlay(Image(.add))
                        }
                    }
                                 .onChange(of: selectedItems) { _, selectedPhoto in
                                     handleSelectedPhotos(selectedPhoto)
                                 }
                    
                    Spacer()
                }
                
                Spacer().frame(height: 24)
                
                VStack(alignment: .leading) {
                    Text("반려견 이름")
                        .font(.body_14_sb)
                    PawkeyTextField(text: $viewModel.userProfile.dogName, placeholder: "이름을 입력해주세요")
                }
                
                Spacer().frame(height: 30)
                
                VStack(alignment: .leading) {
                    Text("성별")
                        .font(.body_14_sb)
                    HStack {
                        ForEach(viewModel.dogGenderList, id: \.self) { dogGender in
                            let isSelected = dogGender == viewModel.userProfile.dogGender
                            LocationButton(dogGender, isSelected: isSelected) { selectedGender in
                                viewModel.changeUserInfo(.dogGender(selectedGender))
                            }
                        }
                    }
                    
                    Button {
                        viewModel.changeUserInfo(.neutered(!viewModel.userProfile.isNeutered))
                    } label: {
                        Text("중성화했어요")
                            .font(.body_14_r)
                            .foregroundStyle(viewModel.userProfile.isNeutered ? .pawkeyBlack : .gray300)
                    }
                }
                
                Spacer().frame(height: 30)
                
                VStack(alignment: .leading) {
                    Text("견종")
                        .font(.body_14_sb)
                    PawkeyTextField(text: $viewModel.userProfile.dogBreed)                    
                }
                
                Spacer().frame(height: 30)
                
                VStack(alignment: .leading) {
                    Text("나이")
                        .font(.body_14_sb)
                    HStack {
                        ForEach(KnownDogAge.allCases, id: \.self) {
                            LocationButton($0.rawValue, isSelected: viewModel.userProfile.knownDogAge != nil ? viewModel.userProfile.knownDogAge == $0 : false) { selected in
                                viewModel.changeUserInfo(.KnownDogAge(.init(rawValue: selected)))
                            }
                        }
                    }
                    if viewModel.userProfile.isKnownAge {
                        PawkeyTextField(text: $viewModel.userProfile.dogAge, placeholder: "나이를 입력해주세요.", type: .number)
                    }
                }
                Spacer().frame(height: 50)
                Spacer()
            }
            .padding(.horizontal, 16)
        }
    }
    
    private func handleSelectedPhotos(_ newPhotos: [PhotosPickerItem]) {
        for newPhoto in newPhotos {
            newPhoto.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    if let data = data, let newImage = UIImage(data: data) {
                        if !profileImage.contains(where: { $0.pngData() == newImage.pngData() }) {
                            DispatchQueue.main.async {
                                profileImage.append(newImage)
                            }
                        }
                    }
                case .failure:
                    break
                }
            }
        }
        
        selectedItems.removeAll()
    }
}
