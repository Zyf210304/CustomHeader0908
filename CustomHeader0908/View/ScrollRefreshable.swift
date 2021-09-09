//
//  ScrollRefreshable.swift
//  CustomHeader0908
//
//  Created by 张亚飞 on 2021/9/8.
//

import SwiftUI


struct ScrollRefreshable<Content: View>: View {
    
    var content: Content
    
    var onRefresh: () async ->()
    
    init(title: String, tintColor: Color, @ViewBuilder content: @escaping () -> Content, onRefresh:@escaping () async ->()) {
        
        self.content = content()
        self.onRefresh = onRefresh
        
        //moving refresh control indicator....
        let refreshControl = UIRefreshControl.appearance()
        
        refreshControl.bounds = CGRect(x: refreshControl.bounds.origin.x,
                                       y: -(350 - getSafeArea().top) + refreshControl.bounds.origin.y,
                                       width: refreshControl.bounds.size.width,
                                       height: refreshControl.bounds.size.height)
        
        
        //modifying refresh control...
        UIRefreshControl.appearance().attributedTitle = NSAttributedString(string: title)
        UIRefreshControl.appearance().tintColor = UIColor(tintColor)
    }
    
    
    var body: some View {
        
        List {
            
            content
                .listRowSeparatorTint(.clear)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .listStyle(.plain)
        .refreshable {
            
            await onRefresh()
        }
    }
}

struct ScrollRefreshable_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
