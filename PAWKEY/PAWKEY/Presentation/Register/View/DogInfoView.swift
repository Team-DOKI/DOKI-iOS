//
//  DogInfoView.swift
//  PAWKEY
//
//  Created by a on 10/31/25.
//

import SwiftUI
import PhotosUI

struct DogInfoView: View {
    @ObservedObject var viewModel: RegisterViewModel
    @State private var selectedItems: [PhotosPickerItem] = []
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                Spacer().frame(height: 20)
                infoViewTitle
                Spacer().frame(height: 40)
                photoPicker
                Spacer().frame(height: 16)
                nickname
                Spacer().frame(height: 16)
                birth
                Spacer().frame(height: 16)
                selectGender
                Spacer().frame(height: 16)
                selectBreed
            }
            .padding(.horizontal, 16)
        }
        .sheet(isPresented: $viewModel.isShowBreedSearch) {
            DogSearchView(viewModel: viewModel)
            .presentationDetents([.height(600)])
        }
    }
}

// MARK: - UI Components

extension DogInfoView {
    private var infoViewTitle: some View {
        VStack(spacing: 4) {
            Text("산책하기 전\n간단한 정보를 입력해주세요").header2()
            Text("서비스 시작을 위해 간단한 정보를 입력해주세요!").bodyDefault()
        }
    }
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
                Image(.dogProfile)
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
            HStack {
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
                HStack {
                    Image(viewModel.isNeutering ? .checked : .unChecked)
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

// MARK: - Helpers

extension DogInfoView {
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
