//
//  SchoolSelectionOnBoardingView.swift
//  tumble-ios
//
//  Created by Adis Veletanlic on 2023-01-28.
//

import SwiftUI

typealias OnSelectSchool = (School) -> Void

struct SchoolSelection: View {
    
    let onSelectSchool: OnSelectSchool
    
    var body: some View {
        ScrollView {
            ForEach(schools, id: \.id) { school in
                SchoolRow(school: school, onSelectSchool: onSelectSchool)
            }
        }
        .padding([.top], 5)
    }
}

struct SchoolSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SchoolSelection(onSelectSchool: {school in })
    }
}
