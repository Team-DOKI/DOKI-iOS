//
//  PetProfileView.swift
//  DOKI
//
//  Created by 안치욱 on 12/30/25.
//

import SwiftUI
import PhotosUI

struct PetProfileView: View {
    @ObservedObject var viewModel: PetProfileViewModel

    @State private var selectedItems: [PhotosPickerItem] = []

    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Spacer().frame(height: 26)
                
                photoPicker
                
                Spacer().frame(height: 30)
                
                nickname
                
                Spacer().frame(height: 16)
                
                birth
                
                Spacer().frame(height: 16)
                
                selectGender
                
                Spacer().frame(height: 16)
                
                selectBreed
                
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .overlay(alignment: .bottom, content: {
            MainButton(
                text: "저장하기",
                action: {}
            )
            .padding(.horizontal, 16)
        })
        .sheet(isPresented: $viewModel.isShowBreedSearch) {
            DogSearch(viewModel: viewModel)
                .presentationDetents([.height(600)])
        }
        .topNavigationView(left: {
            BackButton(action: {
                dismiss()
            })
        }, center: {
            Text("반려견 정보 입력")
                .subtitle()
        })
    }
}

extension PetProfileView {
    private var photoPicker: some View {
        PhotosPicker(
            selection: $selectedItems,
            maxSelectionCount: 1,
            matching: .images
        ) {
            if let profileImage = viewModel.profileImage.last {
                Image(uiImage: profileImage)
                    .resizable()
                    .frame(width: 94, height: 94)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
            } else {
                Image(.btnDogprofile)
            }
        }
        .onChange(of: selectedItems) { _, selectedPhoto in
            handleSelectedPhotos(selectedPhoto)
        }
    }
    
    private var nickname: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("이름").bodyActive()
            
            MainTextField(
                placeholder: "최대 8글자 이내로 입력해주세요",
                text: $viewModel.dogName
            )
        }
    }
    
    private var birth: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("생년월일").bodyActive()
            
            MainTextField(
                placeholder: "YYYY/MM/DD",
                text: $viewModel.dogBirthDay
            )
        }
    }
    
    private var selectGender: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("성별").bodyActive()
            
            HStack(spacing: 4) {
                ForEach(Gender.allCases) { gender in
                    CheckBox(
                        text: gender.dogText,
                        isChecked: viewModel.dogGender == gender
                    ) {
                        viewModel.selectDogGender(gender)
                    }
                }
            }
            
            Button {
                viewModel.toggleIsNeutering()
            } label: {
                HStack(spacing: 8) {
                    Image(viewModel.isNeutering ? .btnNeutralized : .btnNotneutralized)
                    
                    Text("중성화 했어요").bodySmall(color: .defaultMiddle)
                }
            }
        }
    }
    
    private var selectBreed: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("견종").bodyActive()
            
            SearchField(
                placeholder: "견종을 검색해보세요",
                text: $viewModel.breed
            )
            .disabled(true)
            .overlay {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.toggleBreedSearchSheet()
                    }
            }
        }
    }
}

extension PetProfileView {
    private func handleSelectedPhotos(_ newPhotos: [PhotosPickerItem]) {
        for newPhoto in newPhotos {
            newPhoto.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    if let data,
                       let newImage = UIImage(data: data),
                       !viewModel.profileImage.contains(where: { $0.pngData() == newImage.pngData() }) {
                        DispatchQueue.main.async {
                            viewModel.profileImage.append(newImage)
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
