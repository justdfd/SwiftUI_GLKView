//
//  ContentView.swift
//  SwiftUI_GLKView
//
//  Created by Dave Dombrowski on 1/19/20.
//  Copyright © 2020 justDFD. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: Model
    var body: some View {
        VStack {
            GLKViewerVC()
            Button(action: {
                self.showImage()
            }) {
                VStack {
                    Image(systemName:"tv").font(Font.body.weight(.bold))
                    Text("Show image").font(Font.body.weight(.bold))
                }
                .frame(width: 80, height: 80)
            }
        }
    }
    func showImage() {
        NotificationCenter.default.post(name: .updateImage, object: nil, userInfo: nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
