//
//  MapAndListViewModel.swift
//  PAWKEY
//
//  Created by 권석기 on 7/11/25.
//

import SwiftUI

import Moya

final class MapAndListViewModel: ObservableObject {
    
    enum WalkRouteOption {
        case walkingTime(index: Int)
        case safety(index: Int)
        case convenience(index: Int)
        case environment(index: Int)
        case mood(index: Int)
    }
    
    @Published var isShowSheet = false
    @Published var filterItemList = FilterList()
    @Published var expandedGroup: [Int: Bool] = [:]
    @Published var selectedFilterItem: [SelecteItem] = []
    
    func resetAllOptions() {
     
    }
    
    private func selecteSingleOption(at index: Int, from list: [CheckItem]) -> [CheckItem] {
        var newList = list
        
        if let firstIndex = list.firstIndex(where: {$0.isSelected}) {
            newList[firstIndex].isSelected = false
            newList[index].isSelected = true            
        } else {
            newList[index].isSelected = true
        }
        
        return newList
    }
    
    private func selecteMultipleOption(at index: Int, from list: [CheckItem]) -> [CheckItem] {
        var newList = list
        newList[index].isSelected.toggle()
        return newList
    }
}

// MARK: - API

extension MapAndListViewModel {
    
    @MainActor
    func fetchFilterOptions() async {
        let provider = MoyaProvider<FilterAPI>(plugins: [MoyaLoggingPlugin()])
        do {
            let response: BaseDTO<FilterDTO> = try await provider.async.request(.fetchFilterOptions)
            
            guard let data = response.data else {
                return
            }
            
            let selectList = data.selectList.toEntity()
            let categoryList = data.categoryList.toEntity()
            
            filterItemList.selecteList = selectList + Array(categoryList.prefix(2))
            filterItemList.categoryList = Array(categoryList.dropFirst(2))
        } catch {
            print(error.localizedDescription)
        }
    }
}
