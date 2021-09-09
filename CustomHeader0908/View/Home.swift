//
//  Home.swift
//  CustomHeader0908
//
//  Created by 张亚飞 on 2021/9/8.
//

import SwiftUI

struct Home: View {
    
    @State var offset: CGFloat = 0
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            //top nav bar...
            ZStack {
                
                //image issue in swiftui not allowing scroll when its fill
                
                // overcome...
                Image("Pic")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: getScreenBound().width, height: 300, alignment: .bottom)
                    .clipShape(
                        CustomCorner(corners: [.bottomLeft], radius: getCornerRadius())
                    )
                //hiding image
                    .opacity(1 + getProgress())
                
                CustomCorner(corners: [.bottomLeft], radius: getCornerRadius())
                    .fill(.ultraThinMaterial)
                
                let progress = -getProgress() < 0.4 ? getProgress() : -0.4
                //image..
                VStack(alignment: .leading, spacing: 15) {
                    
                    Image("Pic")
                        .resizable()
                        .aspectRatio( contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .scaleEffect(1 + progress * 1.3, anchor: .bottomLeading)
                    
                    Text("sanji")
                        .font(.title.bold())
                        .foregroundColor(.white)
                        .scaleEffect(1 + progress, anchor: .topTrailing)
                        .offset(x: progress * -120, y: progress * 130)
                }
                .padding(15)
                .padding(.bottom, 30)
                // stopping view at bottom...
                // max progress = 0.4
                // 200 * .4 = 80
                //topbar height = 70
                // 10 = padding...
                .offset(y: progress * -200)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            }
            .frame(height: 350)
            //moving up
            .offset(y: getOffset())
            .zIndex(1)
            
            ScrollRefreshable(title: "Pull to Refresh", tintColor: .primary) {
                
                VStack(spacing: 15) {
                    
                    ForEach(1...6, id: \.self) { index in
                        
                        Image("p\(index)")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: getScreenBound().width - 30, height: 250)
                            .cornerRadius(15)
                    }
                }
                .padding()
                .padding(.top, 350)
                //eliminating top edge...
                .padding(.top, -getSafeArea().top)
                .modifier(OffsetModifier(offset: $offset))
                
            } onRefresh: {
                
                // simple waiting for two secs...
                //await Task.sleep(50)
            }

        }
        .ignoresSafeArea(.container, edges: .top)
    }
    
    //preview issue
    func getOffset() -> CGFloat {
        
        //stopping at when navbar size at 70...
        
        //reducing top edge...
        //since we ignored that edge...
        let checkSize = -offset < (280 - getSafeArea().top) ? offset : -(280 - getSafeArea().top)
        
        return offset < 0 ? checkSize : 0
    }
    
    //progress...
    func getProgress() -> CGFloat {
        
        let topheight = (280 - getSafeArea().top)
        let progress = getOffset() / topheight
        
        return progress
    }
    
    //corner Radius
    func getCornerRadius() -> CGFloat {
        
        let radius = getProgress() * 45
        
        return 45 + radius
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


//extending view to get screensize add safe
extension View {
    
    func getScreenBound() -> CGRect {
        
        return UIScreen.main.bounds
    }
    
    func getSafeArea() -> UIEdgeInsets {
        
        let null = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            
            return null
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            
            return null
        }
        
        return safeArea
    }
}
