//
//  MapAndListViewModel.swift
//  PAWKEY
//
//  Created by 권석기 on 7/11/25.
//

import SwiftUI

import Moya

final class MapAndListViewModel: ObservableObject {
    
    private let provider = MoyaProvider<FilterAPI>(plugins: [MoyaLoggingPlugin()])
    
    @Published var posts: [WalkPost] = []
    
    @Published var isShowSheet = false
    @Published var filterItemList = FilterList()
    @Published var sortOptionFilterItem: [SelecteItem] = [
        SelecteItem(selectOptionId: 0, selectText: "최신순"),
        SelecteItem(selectOptionId: 1, selectText: "인기순"),
    ]
    @Published var singleItemexpandedGroup: [Int: Bool] = [:]
    @Published var mutipleItemexpandedGroup: [Int: Bool] = [:]
    @Published var addedFilterItem: [SelecteItem] = []
    @Published var selectedFilterItem: [SelecteItem] = []
    
    @Published var isSearchRequested = false
    
    @Published var myRegion: String = ""
    
    func resetAllOptions() {
        singleItemexpandedGroup = singleItemexpandedGroup.mapValues { _ in false }
        mutipleItemexpandedGroup = singleItemexpandedGroup.mapValues { _ in false }
        
        filterItemList.selecteList = filterItemList.selecteList.map { group in
            var g = group
            g.options = g.options.map {
                SelecteItem(selectOptionId: $0.selectOptionId, selectText: $0.selectText, isSelected: false)
            }
            return g
        }
        
        filterItemList.categoryList = filterItemList.categoryList.map { group in
            var g = group
            g.options = g.options.map {
                SelecteItem(selectOptionId: $0.selectOptionId, selectText: $0.selectText, isSelected: false)
            }
            return g
        }
        
        addedFilterItem = []
        selectedFilterItem = []
    }
    
    func selectSingleItem(_ selected: SelecteItem) {
        guard let groupIndex = filterItemList.selecteList.firstIndex(where: {
            $0.options.contains(where: { $0.selectOptionId == selected.selectOptionId })
        }) else { return }
        
        var group = filterItemList.selecteList[groupIndex]
        group.options = group.options.map {
            SelecteItem(
                selectOptionId: $0.selectOptionId,
                selectText: $0.selectText,
                isSelected: $0.selectOptionId == selected.selectOptionId
            )
        }
        
        filterItemList.selecteList[groupIndex] = group
        
        addedFilterItem.removeAll {
            group.options.map(\.selectOptionId).contains($0.selectOptionId)
        }
        addedFilterItem.append(selected)
    }
    
    func selectMultipleItem(_ selected: SelecteItem) {
        guard let groupIndex = filterItemList.categoryList.firstIndex(where: {
            $0.options.contains(where: { $0.selectOptionId == selected.selectOptionId })
        }) else { return }
        
        var group = filterItemList.categoryList[groupIndex]
        group.options = group.options.map {
            if $0.selectOptionId == selected.selectOptionId {
                return SelecteItem(
                    selectOptionId: $0.selectOptionId,
                    selectText: $0.selectText,
                    isSelected: !$0.isSelected
                )
            }
            return $0
        }
        
        filterItemList.categoryList[groupIndex] = group
        
        if let index = addedFilterItem.firstIndex(where: { $0.selectOptionId == selected.selectOptionId }) {
            addedFilterItem.remove(at: index)
        } else {
            addedFilterItem.append(selected)
        }
    }
    
    func selectSortItem(_ selectId: Int) {
        if let index = sortOptionFilterItem.firstIndex(where: {$0.selectOptionId == selectId }) {
            sortOptionFilterItem[index].isSelected.toggle()
        }
    }
    
    @MainActor
    func saveFilterOption() async {
        self.selectedFilterItem = addedFilterItem
        self.isShowSheet = false
        
        let selectedFilterRequest =  filterItemList.selecteList.filter { !($0.options.filter { $0.isSelected }.isEmpty) }
            .map { SelectedOption(categoryId: $0.selectId, optionsIds: $0.options.filter { $0.isSelected }.map { $0.selectOptionId })}
        let categoryFilterRequest = filterItemList.categoryList.filter { !($0.options.filter { $0.isSelected }.isEmpty) }
            .map { SelectedOption(categoryId: $0.selectId, optionsIds: $0.options.filter { $0.isSelected }.map { $0.selectOptionId })}
        let filterRequest = FilterRequest(durationStart: "", durationEnd: "", selectedOptions: selectedFilterRequest + categoryFilterRequest)
        
        await fetchFilteredPosts(filterRequest)
    }
    
    func onTapSingleItemGroup(selectId: Int) {
        if singleItemexpandedGroup[selectId] == true {
            singleItemexpandedGroup = singleItemexpandedGroup.mapValues { _ in false }
            singleItemexpandedGroup.updateValue(false, forKey: selectId)
        } else {
            singleItemexpandedGroup = singleItemexpandedGroup.mapValues { _ in false }
            singleItemexpandedGroup.updateValue(true, forKey: selectId)
        }
    }
    
    func onTapMutipleItemGroup(selectId: Int) {
        if mutipleItemexpandedGroup[selectId] == true {
            mutipleItemexpandedGroup = mutipleItemexpandedGroup.mapValues { _ in false }
            mutipleItemexpandedGroup.updateValue(false, forKey: selectId)
        } else {
            mutipleItemexpandedGroup = mutipleItemexpandedGroup.mapValues { _ in false }
            mutipleItemexpandedGroup.updateValue(true, forKey: selectId)
        }
    }
}

// MARK: - API

extension MapAndListViewModel {
    @MainActor
    func fetchPosts() async {
        let provider = MoyaProvider<WalkPostAPI>(plugins: [MoyaLoggingPlugin()])
        
        do {
            let response: BaseDTO<PostDataDTO> = try await provider.async.request(.fetchPosts(.init()))
            
            guard let data = response.data else {
                return
            }
            self.posts = data.posts.toEntity()
        } catch {
            print("에러 발생: \(error.localizedDescription)")
        }
        isSearchRequested = true
    }
    
    @MainActor
    func fetchFilteredPosts(_ filterRequest: FilterRequest) async {
        let provider = MoyaProvider<WalkPostAPI>(plugins: [MoyaLoggingPlugin()])
        do {
            let response: BaseDTO<PostDataDTO> = try await provider.async.request(.fetchPosts(filterRequest))
            
            guard let data = response.data else {
                return
            }
            
            self.posts = data.posts.toEntity()
        } catch {
            print(error.localizedDescription)
        }
        isSearchRequested = true
    }
    
    @MainActor
    func fetchFilterOptions() async {
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
    
    @MainActor
    func fetchMyRegion() async {
        let provider = MoyaProvider<MyRegionAPI>()
        
        do {
            let response: BaseDTO<MyRegionDTO> = try await provider.async.request(.fetchMyRegion)
            
            guard let data = response.data else {
                return
            }
            
            self.myRegion = data.fullRegionName
            
            print(myRegion)
        } catch {
            print("Error fetching regions: \(error.localizedDescription)")
        }
    }
}
