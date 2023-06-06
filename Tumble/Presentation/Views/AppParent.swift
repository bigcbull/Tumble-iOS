//
//  HomeView.swift
//  Tumble
//
//  Created by Adis Veletanlic on 11/20/22.
//

import SwiftUI
import PopupView

// All navigation occurs from this view
struct AppParent: View {
    @ObservedObject var viewModel: ParentViewModel
    @ObservedObject var appController: AppController = .shared
    
    private let navigationBarAppearance = UINavigationBar.appearance()
    
    init(viewModel: ParentViewModel) {
        navigationBarAppearance.titleTextAttributes = [.font: navigationBarFont()]
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(named: "OnSurface")!]
        self.viewModel = viewModel
        
        let barAppearance = UIBarAppearance()
        let tabBarAppearance = UITabBar.appearance()
        barAppearance.configureWithDefaultBackground()
        tabBarAppearance.scrollEdgeAppearance = .init(barAppearance: barAppearance)
    }
    
    var body: some View {
        TabView(selection: $appController.selectedAppTab) {
            NavigationView {
                Home(
                    viewModel: viewModel.homeViewModel,
                    parentViewModel: viewModel,
                    selectedAppTab: $appController.selectedAppTab
                )
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(NSLocalizedString("Home", comment: ""))
            }
            .tabItem {
                TabItem(appTab: TabbarTabType.home, selectedAppTab: $appController.selectedAppTab)
            }
            .tag(TabbarTabType.home)
            
            NavigationView {
                Bookmarks(
                    viewModel: viewModel.bookmarksViewModel,
                    parentViewModel: viewModel
                )
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarTitle(NSLocalizedString("Bookmarks", comment: ""))
            }
            .tabItem {
                TabItem(appTab: TabbarTabType.bookmarks, selectedAppTab: $appController.selectedAppTab)
            }
            .tag(TabbarTabType.bookmarks)
            
            NavigationView {
                Search(viewModel: viewModel.searchViewModel)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle(NSLocalizedString("Search", comment: ""))
            }
            .tabItem {
                TabItem(appTab: TabbarTabType.search, selectedAppTab: $appController.selectedAppTab)
            }
            .tag(TabbarTabType.search)
            
            NavigationView {
                Account(viewModel: viewModel.accountPageViewModel)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle(NSLocalizedString("Account", comment: ""))
                    .navigationBarItems(trailing: HStack {
                        NavigationbarSettings(
                            viewModel: viewModel.settingsViewModel
                        )
                    })
            }
            .tabItem {
                TabItem(appTab: TabbarTabType.account, selectedAppTab: $appController.selectedAppTab)
            }
            .tag(TabbarTabType.account)
        }
        .tint(.primary)
        .popup(isPresented: $appController.showPopup) {
            if let popup = appController.popup {
                PopupContainer(popup: popup)
            }
        } customize: {
            $0
                .type(.floater())
                .position(.bottom)
                .animation(.spring())
                .closeOnTapOutside(true)
                .autohideIn(5)
        }
        .ignoresSafeArea(.keyboard)
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $viewModel.userNotOnBoarded, content: {
            OnBoarding(finishOnBoarding: viewModel.finishOnboarding)
        })
    }
}

