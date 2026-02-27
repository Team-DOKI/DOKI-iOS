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
    
    @State private var selectedItem: PhotosPickerItem?
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView(showsIndicators: false) {
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
        .safeAreaInset(edge: .bottom) {
            MainButton(
                text: "저장하기",
                action: {
                    viewModel.saveButtonTapped(petId: 17)
                }
            )
            .padding(.horizontal, 16)
        }
        .ignoresSafeArea(.keyboard)
        .onAppear{ viewModel.fetchBreedList() }
        .onChange(of: viewModel.isSaveCompleted) { _, completed in
            if completed {
                dismiss()
            }
        }
        .sheet(isPresented: $viewModel.isShowBreedSearch) {
            BreedSearchView(
                breeds: viewModel.breedList,
                selectedBreedName: viewModel.selectedBreedName,
                searchText: $viewModel.breedSearchText,
                onSelect: { breed in
                    viewModel.selectBreed(breed)
                },
                onDismiss: {
                    viewModel.toggleBreedSearchSheet()
                }
            )
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
            selection: $selectedItem,
            matching: .images
        ) {
            if let newImage = viewModel.newPetProfileImage {
                Image(uiImage: newImage)
                    .resizable()
                    .frame(width: 94, height: 94)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
            }
            else if let urlString = viewModel.petProfileImageUrl,
                    let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .frame(width: 94, height: 94)
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                        .frame(width: 94, height: 94)
                }
            }
            else {
                Image(.btnDogprofile)
            }
        }
        .onChange(of: selectedItem) { _, newItem in
            guard let newItem else { return }
            handleSelectedPhoto(newItem)
        }
    }
    
    private var nickname: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("이름").bodyActive()
            
            MainTextField(
                placeholder: "최대 8글자 이내로 입력해주세요",
                text: $viewModel.dogName
            )
            .onChange(of: viewModel.dogName) { _, newValue in
                if newValue.count > 8 {
                    viewModel.dogName = String(newValue.prefix(8))
                }
            }
        }
    }
    
    private var birth: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("생년월일").bodyActive()
            
            MainTextField(
                placeholder: "YYYY/MM/DD",
                text: $viewModel.dogBirthDay
            )
            .keyboardType(.numberPad)
            .onChange(of: viewModel.dogBirthDay) { old, new in
                guard new.count >= old.count else { return }
                
                let formatted = viewModel.autoFormatBirth(new)
                if formatted != new {
                    viewModel.dogBirthDay = formatted
                }
            }
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
                viewModel.toggleIsNeutered()
            } label: {
                HStack(spacing: 8) {
                    Image(viewModel.isNeutered ? .btnNeutralized : .btnNotneutralized)
                    
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
                text: $viewModel.selectedBreedName
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

extension PetProfileView {
    private func handleSelectedPhoto(_ item: PhotosPickerItem) {
        item.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let data):
                guard
                    let data,
                    let image = UIImage(data: data)
                else { return }
                
                DispatchQueue.main.async {
                    viewModel.uploadDogImage(image)
                }
                
            default:
                print("이미지를 불러오지 못했습니다.")
            }
        }
    }
}
