//
//  HomeView.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

import Moya

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    
    private let provider = MoyaProvider<RegionAPI>(session: .init(interceptor: AuthInterceptor.shared), plugins: [NetworkLoggerPlugin()])
    @State var errorMessage = ""
    
    var body: some View {
        VStack {
            Text("홈")
            Text(errorMessage)
        }
            .task {
                do {
                    let response: BaseDTO<DistrictDTO> = try await provider.async.request(.getRegions)
                } catch {
                    print(error.localizedDescription)
                    errorMessage = error.localizedDescription
                }
            }
    }
}
