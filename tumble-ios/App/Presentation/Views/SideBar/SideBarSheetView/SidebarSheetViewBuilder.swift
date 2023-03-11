//
//  SidebarSheetBuilder.swift
//  tumble-ios
//
//  Created by Adis Veletanlic on 2023-02-09.
//

import SwiftUI

struct SidebarSheetViewBuilder<Content : View>: View {
    
    let header: String
    let content: Content
    let dismiss: () -> Void
    
    init(header: String, dismiss: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.header = header
        self.dismiss = dismiss
    }
    
    var body: some View {
        VStack (spacing: 0) {
            HStack {
                Text(header)
                    .sheetTitle()
                Spacer()
                Button(action: dismiss, label: {
                    Text("Done")
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                        .foregroundColor(.primary)
                        .padding([.bottom, .top], 20)
                        .padding([.leading, .trailing], 20)
                })
            }
            Divider()
                .padding(.bottom, 15)
            content
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
