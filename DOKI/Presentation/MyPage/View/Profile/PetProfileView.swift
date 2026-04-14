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
    @State private var isShowPhotoSheet = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            mainContent
            
            if isShowPhotoSheet {
                photoBottomSheet
            }
        }
        .ignoresSafeArea(.keyboard)
        .onAppear { viewModel.fetchBreedList() }
        .onChange(of: viewModel.isSaveCompleted) { _, completed in
            if completed {
                dismiss()
                viewModel.isSaveCompleted = false
            }
        }
        .onChange(of: selectedItem) { _, newItem in
            guard let newItem else { return }
            
            withAnimation {
                    isShowPhotoSheet = false
                }
            
            handleSelectedPhoto(newItem)
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
    private var mainContent: some View {
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
                buttonState: viewModel.buttonDisabled ? .disabled : .active1,
                action: {
                    viewModel.saveButtonTapped(petId: AuthManager.shared.petId)
                }
            )
            .padding(.horizontal, 16)
        }
    }
}

extension PetProfileView {
    private var photoBottomSheet: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    isShowPhotoSheet = false
                }
            
            VStack {
                Spacer()
                
                VStack(spacing: 10) {
                    VStack(spacing: 0) {
                        PhotosPicker(
                            selection: $selectedItem,
                            matching: .images
                        ) {
                            Text("갤러리")
                                .mainDefault(color: .defaultPrimary)
                                .frame(maxWidth: .infinity, minHeight: 56)
                        }
                        
                        Divider()
                        
                        Button {
                            isShowPhotoSheet = false
                            viewModel.setDefaultImage()
                        } label: {
                            Text("기본 이미지")
                                .mainDefault(color: .defaultPrimary)
                                .frame(maxWidth: .infinity, minHeight: 56)
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(16)
                    
                    Button {
                        withAnimation {
                            isShowPhotoSheet = false
                        }
                    } label: {
                        Text("취소")
                            .frame(maxWidth: .infinity, minHeight: 56)
                            .background(Color.defaultPrimary)
                            .foregroundStyle(.white)
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 16)
                .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut, value: isShowPhotoSheet)
    }
}

extension PetProfileView {
    private var photoPicker: some View {
        Button {
            withAnimation {
                isShowPhotoSheet = true
            }
        } label: {
            ZStack(alignment: .bottomTrailing) {
                Group {
                    if let newImage = viewModel.newPetProfileImage {
                        Image(uiImage: newImage)
                            .resizable()
                    }
                    else if let urlString = viewModel.petProfileImageUrl,
                            let url = URL(string: urlString) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    else {
                        Image(.imgDefaultprofile)
                            .resizable()
                    }
                }
                .frame(width: 94, height: 94)
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                
                Image(.btnEditprofile)
            }
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
                
                let formatted = new.formattedBirthDate()
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
                    GenderSelectButton(
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
                    viewModel.presignedURL(image)
                }
                
            default:
                print("이미지를 불러오지 못했습니다.")
            }
        }
    }
}
