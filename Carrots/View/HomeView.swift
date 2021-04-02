//
//  HomeView.swift
//  Carrots
//
//  Created by Benjamin Breton on 01/04/2021.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: ViewModel = ViewModel()
    @State private var selection = 0
    let titles: [String] = ["Pots", "Athletics"]
    let images: [String] = ["creditcard.circle.fill", "figure.walk.circle.fill"]
    var body: some View {
        UITabBar.appearance().backgroundImage = UIImage()
        return NavigationView {
            TabView(selection: $selection) {
                PotsView()
                    .tabItem {
                        Image(systemName: images[0])
                        Text(titles[0])
                    }
                    .tag(0)
                PotsView()
                    .tabItem {
                        Image(systemName: images[1])
                        Text(titles[1])
                    }
                    .tag(1)
            }
            .navigationBarTitle(Text(titles[selection]))
            .accentColor(.black)
        }
        
    }
}

struct PotsView: View {
    var body: some View {
        VStack {
            Divider()
            Text("Common pot")
                .inCellRectangle()
            Divider()
            Text("Athletics pots")
            ListBase()
            Divider()
        }
        .withAppBackground()
    }
}
struct ListBase: View {
    let items = ["&", "h", "k", "l", "m", "p"]
    var body: some View {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        return List {
            ForEach(items.indices) { index in
                Text(items[index])
                    .inCellRectangle()
            }
            .listRowBackground(Color.clear)
            
                
        }

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
                .frame(width: .none, height: UIScreen.main.bounds.height / 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
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
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewDevice("iPhone 12")
        HomeView()
            .previewDevice("iPhone SE (1st generation)")
    }
}
