//
//  DogInfoView.swift
//  PAWKEY
//
//  Created by 권석기 on 7/9/25.
//

import SwiftUI
import PhotosUI

struct DogInfoView: View {
    @State var profileImage: [UIImage] = []
    @State var selectedItems: [PhotosPickerItem] = []
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                
                Spacer().frame(height: 20)
                
                Text("견주님의 반려견이 궁금해요!")
                    .font(.head_22_sb)
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
                
                VStack(alignment:.leading) {
                    Text("반려견 이름")
                        .font(.body_14_sb)
                    PKTextField(text: .constant(""))
                }
                
                Spacer().frame(height: 30)
                
                VStack(alignment:.leading) {
                    Text("성별")
                        .font(.body_14_sb)
                    HStack {
                        ChoiceButton("남아")
                        ChoiceButton("여아")
                    }
                }
                
                Spacer().frame(height: 30)
                
                VStack(alignment:.leading) {
                    Text("견종")
                        .font(.body_14_sb)
                    PKTextField(text: .constant(""))
                }
                
                Spacer().frame(height: 30)
                
                VStack(alignment:.leading) {
                    Text("나이")
                        .font(.body_14_sb)
                    HStack {
                        ChoiceButton("나이를 알아요")
                        ChoiceButton("나이를 몰라요")
                    }
                }
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

#Preview {
    DogInfoView()
}
