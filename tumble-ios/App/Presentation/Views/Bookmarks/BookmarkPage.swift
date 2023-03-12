//
//  SchedulePageMainView.swift
//  tumble-ios
//
//  Created by Adis Veletanlic on 11/21/22.
//

import SwiftUI

struct BookmarkPage: View {
    
    @ObservedObject var viewModel: BookmarkPageViewModel
    @ObservedObject var appController: AppController
    
    var body: some View {
        VStack (alignment: .center) {
            VStack {
                Picker("ViewType", selection: $viewModel.defaultViewType) {
                    ForEach(viewModel.scheduleViewTypes, id: \.self) {
                        Text($0.rawValue)
                            .foregroundColor(.onSurface)
                            .font(.caption)
                    }
                }
                .onChange(of: viewModel.defaultViewType) { defaultViewType in
                    viewModel.onChangeViewType(viewType: defaultViewType)
                }
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .padding(.top, 10)
                .pickerStyle(SegmentedPickerStyle())
                .foregroundColor(.primary)
                
                switch viewModel.status {
                case .loading:
                    Spacer()
                    HStack {
                        Spacer()
                        CustomProgressIndicator()
                        Spacer()
                    }
                    Spacer()
                case .loaded:
                    switch viewModel.defaultViewType {
                    case .list:
                        BookmarkListView(
                            days: viewModel.scheduleListOfDays,
                            courseColors: viewModel.courseColors,
                            parentViewModel: viewModel
                        )
                        
                    case .calendar:
                        Text("stub")
                            .padding(.top, 10)
                    }
                case .uninitialized:
                    Info(title: "No bookmarks yet", image: "bookmark.slash")
                case .error:
                    Info(title: "There was an error retrieving your schedules", image: "exclamationmark.circle")
                case .hiddenAll:
                    Info(title: "All your bookmarks are hidden", image: "bookmark.slash")
                }
            }
        }
        .onAppear {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        /// Event sheet specifically for when a notification has been opened outside
        /// the application by the user. The shared eventSheet value is changed from
        /// AppDelegate and launched here.
        .sheet(item: $appController.eventSheet) { (eventSheet: EventDetailsSheetModel) in
            EventDetailsSheet(viewModel: viewModel.generateViewModelEventSheet(event: eventSheet.event, color: eventSheet.color), updateCourseColors: updateCourseColors)
        }
        .sheet(item: $viewModel.eventSheet) { (eventSheet: EventDetailsSheetModel) in
            EventDetailsSheet(viewModel: viewModel.generateViewModelEventSheet(event: eventSheet.event, color: eventSheet.color), updateCourseColors: updateCourseColors)
        }
    }
    
    func updateCourseColors() -> Void {
        self.viewModel.updateCourseColors()
    }

    
}

