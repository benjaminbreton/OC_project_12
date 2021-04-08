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
        UINavigationBar.appearance().titleTextAttributes = [.font : CommonSettings().regularNavigationTitleFont]
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : CommonSettings().largeNavigationTitleFont]
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
                        .frame(width: CommonSettings().navigationButtonSize, height: CommonSettings().navigationButtonSize, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
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

struct BigTitleFont: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.custom("akaPosse", size: CommonSettings().bigTitleFontSize))
    }
}
struct TitleFont: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.custom("kirsty", size: CommonSettings().titleFontSize))
    }
}
struct SimpleFont: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.custom("kirsty", size: CommonSettings().regularFontSize))
    }
}

struct NoListRectangle: ViewModifier {
    func body(content: Content) -> some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .opacity(0.2)
            content
                .padding()
        }
        .padding()
    }
}

struct CellRectangle: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .opacity(0.2)
            content
        }
        .padding()
    }
}

struct BackgroundView: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [.gray, .orange]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .edgesIgnoringSafeArea(.all)
            content
        }
    }
}

extension View {
    func withAppBackground() -> some View {
        modifier(BackgroundView())
    }
    func inCellRectangle() -> some View {
        modifier(CellRectangle())
    }
    func inNoListRectangle() -> some View {
        modifier(NoListRectangle())
    }
    func withTitleFont() -> some View {
        modifier(TitleFont())
    }
    func withSimpleFont() -> some View {
        modifier(SimpleFont())
    }
    func withBigTitleFont() -> some View {
        modifier(BigTitleFont())
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

class CommonSettings {
    var commonPotLineHeight: CGFloat {
        UIScreen.main.bounds.height / 10
    }
    var regularFontSize: CGFloat {
        return 20 * UIScreen.main.bounds.height / 844
    }
    var titleFontSize: CGFloat {
        return regularFontSize * 1.5
    }
    var bigTitleFontSize: CGFloat {
        return regularFontSize * 1.5
    }
    var navigationTitleFontSize: CGFloat {
        return regularFontSize * 2.5
    }
    var navigationButtonSize: CGFloat {
        return 30 * UIScreen.main.bounds.height / 844
    }
    var regularNavigationTitleFont: UIFont {
        guard let regularTitleFont = UIFont(name: "akaPosse", size: CommonSettings().regularFontSize) else { return UIFont() }
        return regularTitleFont
    }
    var largeNavigationTitleFont: UIFont {
        guard let largeTitleFont = UIFont(name: "akaPosse", size: CommonSettings().navigationTitleFontSize) else { return UIFont() }
        return largeTitleFont
    }
}
