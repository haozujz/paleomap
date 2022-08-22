//
//  SearchView.swift
//  Paleo
//
//  Created by Joseph Zhu on 18/7/2022.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var modelData: ModelData
    @EnvironmentObject private var searchModel: SearchModel
    @Binding var currentTab: TabBarItem
    
    var body: some View {
        NavigationView {
            SearchableView(currentTab: $currentTab)
        }
        .navigationViewStyle(.stack)
        .searchable(text: $searchModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Phylum, Order, Class, Family, Name") {
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Discover")
                    .font(.system(size: 32, weight: .heavy)).foregroundColor(Color(red:0.8, green:0.8, blue:0.8))
            }
        }
        .onSubmit(of: .search) { [weak searchModel] in
            guard let searchModel = searchModel else {return}
            searchModel.search(grid: modelData.grid)
        }
        .onAppear { [weak modelData] in
            guard let modelData = modelData else {return}
            modelData.bookmarked.sort {$0.family < $1.family}
        }
        .ignoresSafeArea(.keyboard)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(currentTab: .constant(.search))
    }
}

