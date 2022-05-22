//
//  ItemsToolbar.swift
//  JobRecord
//
//  Created by Darek Barańczuk on 21/05/2022.
//

import SwiftUI

struct ItemsToolbar : ToolbarContent {
    
    @State var saved = false
    
    let save: () -> Void
    let open: () -> Void
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Button(action: { save() }) {
                Image(systemName: "tray.and.arrow.down")
                    .renderingMode(.template)
                    .foregroundColor(saved ? Color.white : Color.red)
            }
        }
        ToolbarItem(placement: .primaryAction) {
            Button(action: { open() }) {
                Image(systemName: "tray.and.arrow.up")
                    .renderingMode(.template)
                    .foregroundColor(Color.white)
            }
        }
    }
}
