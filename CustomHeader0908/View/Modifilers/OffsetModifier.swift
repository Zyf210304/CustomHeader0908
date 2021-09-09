//
//  OffsetModifier.swift
//  CustomHeader0908
//
//  Created by 张亚飞 on 2021/9/8.
//

import SwiftUI

// To get scroll offset...
struct OffsetModifier: ViewModifier {
    
    @Binding var offset: CGFloat
    @State var startOffset: CGFloat = 0
    
    func body(content: Content) -> some View {
        
        content
            .overlay(
            
                GeometryReader{ proxy in
                    
                    Color.clear
                    .preference(key: Offsetkey.self, value: proxy.frame(in: .global).minY)
                }
            )
            .onPreferenceChange(Offsetkey.self) { offset in
                
                if startOffset == 0 {
                    
                    startOffset = offset
                }
                self.offset = offset - startOffset
                print(self.offset)
            }
    }
}

// creating scrolloffset prefrece...
struct Offsetkey: PreferenceKey {
    
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        
        value = nextValue()
    }
}
