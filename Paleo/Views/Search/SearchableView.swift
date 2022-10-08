//
//  SearchableView.swift
//  Paleo
//
//  Created by Joseph Zhu on 22/7/2022.
//

import SwiftUI

struct SearchableView: View {
    @EnvironmentObject private var modelData: ModelData
    @EnvironmentObject var searchModel: SearchModel
    @Binding var currentTab: TabBarItem
    
    //note: isSearching changes to false for an instant on view appear before changing back to true if: isSearching was true on view disappear and searchbar/text was in focus (AttributeGraph cycle detected)
    @Environment(\.isSearching) private var isSearchbarActive
    
    enum SearchState: Hashable, Equatable {
        case home, searching, results
    }
    var searchState: SearchState {
        if !isSearchbarActive {return .home}
        else if searchModel.isSearching {return .searching}
        else {return .results}
    }
    var subtitle: String {
        if (searchState == .home) {return "Bookmarks"}
        else if searchState == .results && searchModel.results.count > 0 {return "Records: " + searchModel.lastCompletedSearch}
        else if searchState == .results && searchModel.results.count == 0 && searchModel.lastSubmittedText == "" {return "No Search"}
        else if searchState == .results && searchModel.results.count == 0 {return "No Records found: " + searchModel.lastCompletedSearch}
        else {return "Searching: " + searchModel.lastSubmittedText}
    }
    
    var body: some View {
        GeometryReader { [weak modelData, weak searchModel] _ in
            if let modelData = modelData, let searchModel = searchModel {
                
                VStack(spacing: 12) {
                    Text(subtitle)
                        .font(.system(size: 24, weight: .heavy)).foregroundColor(Color(red:0.8, green:0.8, blue:0.8))
                        .frame(width: 320, height: 28, alignment: .leading)
                        .offset(x: -12)
                        
                    ScrollView {
                        Spacer(minLength: 15)
                        
                        switch searchState {
                        case .home:
                            LazyVStack {
                                ForEach(modelData.bookmarked, id: \.id) { record in
                                    RecordBookmark(currentTab: $currentTab, record: record)
                                        .padding(.vertical, 5)
                                        .frame(width: 320.0, height: 80.0, alignment: .center)
                                }
                            }
                        case .searching:
                                ProgressView()
                                    .scaleEffect(5)
                                    .frame(width: 100, height: 100)
                                    .offset(y: 240)
                        case .results:
                            LazyVStack {
                                ForEach(searchModel.results, id: \.id) { record in
                                    RecordBookmark(currentTab: $currentTab, record: record)
                                        .padding(.vertical, 5)
                                        .frame(width: 320.0, height: 80.0, alignment: .center)
                                }
                            }
                        }
                    }
                    //UIScreen.main.bounds.size.height > 843 ? 560 : UIScreen.main.bounds.size.height - 284
                    .frame(width: 370, height: min((UIScreen.main.bounds.size.height - 284), 600))
                    .allowsHitTesting(searchState == .searching ? false : true)
                    
                    if UIScreen.main.bounds.size.height > 843 {
                        Rectangle()
                            .fill(Color(red:0.03, green:0.03, blue:0.03))
                            .blur(radius: 3)
                            .frame(width: 390, height: 10)
                            .offset(y: -1 * min((UIScreen.main.bounds.size.height - 284), 600) - 17) //-565 - 12
                        
                        Rectangle()
                            .fill(Color(red:0.03, green:0.03, blue:0.03))
                            .blur(radius: 3)
                            .frame(width: 390, height: 10)
                            .offset(y: -15 - 24)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(maxHeight: .infinity, alignment: .center)
                .background(alignment: .center) {
                    Color(red:0.03, green:0.03, blue:0.03)
                        .ignoresSafeArea(.all, edges: .all)
                        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
                        .position(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Discover")
                            .font(.system(size: 32, weight: .heavy)).foregroundColor(Color(red:0.8, green:0.8, blue:0.8))
                    }
                }
            }
        }
    }
}

struct SearchableView_Previews: PreviewProvider {
    static var previews: some View {
        SearchableView(currentTab: .constant(.search))
    }
}
