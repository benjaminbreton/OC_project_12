//
//  HomeView.swift
//  Carrots
//
//  Created by Benjamin Breton on 01/04/2021.
//

import SwiftUI

struct HomeView: View {
    //@ObservedObject var viewModel: ViewModel = ViewModel()
    var viewModel = FakeViewModel.create()
    @State private var selection = 0
    
    let types: [PageType] = [.pots, .athletics, .sports, .performances]
    
    var body: some View {
        UITabBar.appearance().backgroundImage = UIImage()
        UINavigationBar.appearance().titleTextAttributes = [.font : ViewCommonSettings().regularNavigationTitleFont]
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : ViewCommonSettings().largeNavigationTitleFont]
        return NavigationView {
            TabView(selection: $selection) {
                ForEach(types.indices) { index in
                    types[index].view(index, viewModel: viewModel)
                }
            }
            .navigationBarTitle(Text(types[selection].name))
            .navigationBarItems(trailing: types[selection].getNavigationLink(viewModel))
            .accentColor(.black)
        }.accentColor(.black)
        
    }
    enum PageType {
        case pots, athletics, performances, sports
        var name: String {
            switch self {
            case .pots:
                return "Pots"
            case .athletics:
                return "Athletics"
            case .performances:
                return "Performances"
            case .sports:
                return "Sports"
            }
        }
        var image: String {
            switch self {
            case .pots:
                return "creditcard.circle.fill"
            case .athletics:
                return "figure.walk.circle.fill"
            case .performances:
                return "arrow.up.right.circle.fill"
            case .sports:
                return "bicycle.circle.fill"
            }
        }
    
        private var navigationButtonImage: String {
            switch self {
            case .pots:
                return "gear"
            case .athletics:
                return "person.crop.circle.badge.plus"
            case .performances:
                return "gauge.badge.plus"
            case .sports:
                return "plus.circle"
            }
        }
        func getNavigationLink(_ viewModel: FakeViewModel) -> some View {

//            switch self {
//            case .pots:
//                destination = PotsSettingsView()
//            case .athletics:
//                destination = PotsSettingsView()
//            case .performances:
//                destination = PotsSettingsView()
//            case .sports:
//                destination = PotsSettingsView()
//            }
            return NavigationLink(
                destination: PotsSettingsView(viewModel: viewModel, newDate: viewModel.predictedAmountDate),
                label: {
                    Image(systemName: navigationButtonImage)
                        .resizable()
                        .foregroundColor(.black)
                        .frame(width: ViewCommonSettings().navigationButtonSize, height: ViewCommonSettings().navigationButtonSize, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                })
        }
        func view(_ tag: Int, viewModel: FakeViewModel) -> some View {
        //func view(_ tag: Int, viewModel: ViewModel) -> some View {
            switch self {
            case .pots:
                return PotsView(viewModel: viewModel)
                    .tabItem {
                        Image(systemName: image)
                        Text(name)
                    }
                    .tag(tag)
            case .athletics:
                return PotsView(viewModel: viewModel)
                    .tabItem {
                        Image(systemName: image)
                        Text(name)
                    }
                    .tag(tag)
            case .performances:
                return PotsView(viewModel: viewModel)
                    .tabItem {
                        Image(systemName: image)
                        Text(name)
                    }
                    .tag(tag)
            case .sports:
                return PotsView(viewModel: viewModel)
                    .tabItem {
                        Image(systemName: image)
                        Text(name)
                    }
                    .tag(tag)
            }
        }
    }
}











struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewDevice("iPhone 12")
        HomeView()
            .previewDevice("iPhone SE (1st generation)")
    }
}

