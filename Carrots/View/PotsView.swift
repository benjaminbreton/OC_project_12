//
//  PotsView.swift
//  Carrots
//
//  Created by Benjamin Breton on 02/04/2021.
//

import SwiftUI
struct PotsView: View {
    //let viewModel: ViewModel
    let viewModel: FakeViewModel
    
    var body: some View {
        let athleticsPots = viewModel.athletics.map({$0.pot})
        return VStack {
            Divider().padding()
            NavigationPotCell(pot: viewModel.commonPot)
                .frame(width: .none, height: CommonSettings().commonPotLineHeight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Divider().padding()
            Text("Athletics pots")
                .withBigTitleFont()
            if athleticsPots.count > 0 {
                ListBase(items: athleticsPots.map({
                    NavigationPotCell(pot: $0)
                    
                    
                }))
            } else {
                Text("""
                    No athletics have been added.

                    To add an athletic :
                    - select Athletics tab below ;
                    - select the + button on the top of the screen ;
                    - add new athletic's informations and confirm.
                    """)
                    .inNoListRectangle()
            }
            
            Divider()
        }
        .withAppBackground()
    }
}

struct PotAddings: View {
    let pot: FakePot?
    @State var changeType: Int = 0
    @State var amount: String = ""
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            Text(pot?.owner?.name ?? "Common pot")
                .withTitleFont()
            Divider().padding()
            Picker(selection: $changeType, label: Text("Which modification do you want to do on this pot ?"), content: {
                Text("+ Add money")
                    .tag(0)
                    .withSimpleFont()
                Text("- Withdraw money")
                    .tag(1)
                    .withSimpleFont()
            })
            .pickerStyle(SegmentedPickerStyle())
            Divider().padding()
            TextField("Amount", text: $amount)
                .withSimpleFont()
                .keyboardType(.decimalPad)
            Divider().padding()
            Button("Confirm", action: {
                mode.wrappedValue.dismiss()
            })
        }
        .inNavigationPageView(title: "Pot modification")
    }
}

struct NavigationPotCell: View {
    let pot: FakePot?
    var name: String {
        if let athletic = pot?.owner {
            return athletic.name ?? ""
        } else {
            return "Common pot"
        }
    }
    var body: some View {
        PotCell(pot: pot).withNavigationLink(destination: PotAddings(pot: pot))
    }
}
extension View {
    func withNavigationLink<T: View>(destination: T) -> some View {
        modifier(NavigationLinkOnModifier(destination: destination))
    }
    func inNavigationPageView(title: String) -> some View {
        modifier(NavigationPageView(title: title))
    }
}
struct NavigationLinkOnModifier<T: View>: ViewModifier {
    let destination: T
    func body(content: Content) -> some View {
        NavigationLink(
            destination: destination,
            label: {
                content
            })
    }
}

struct PotCell: View {
    //let pot: Pot?
    let pot: FakePot?
    var name: String {
        if let athletic = pot?.owner {
            return athletic.name ?? ""
        } else {
            return "Common pot"
        }
    }
    var body: some View {
        VStack() {
            HStack {
                Text(name)
                    .withTitleFont()
                Text("\(pot?.formattedAmount ?? "")")
                    .withTitleFont()
                    .layoutPriority(1)
            }
            
            Divider()
            HStack {
                GeometryReader { geometry in
                    Image(systemName: pot?.formattedEvolutionType.image.name ?? "arrow.forward.square")
                        .resizable()
                        //                    .scaledToFit()
                        .layoutPriority(0.5)
                        .frame(width: geometry.size.height, height: geometry.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(pot?.formattedEvolutionType.image.colorInt16.potEvolutionColor)
                }
                
                
                Text("expected: \(pot?.formattedAmount ?? "")")
                    .withSimpleFont()
                    .scaledToFill()
                    .layoutPriority(1)
            }
            
        }
        .padding()
        .inCellRectangle()
    }
}
struct PotsSettingsView: View {
    let viewModel: FakeViewModel
    @State var newDate: Date
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        VStack() {
            Divider()
            Text("""
                                The application provides, for each pot, an expected amount on a certain date if athletics keep adding performances on the same rythm.
                                
                                You can set this date here.
                                """)
                .withSimpleFont()
            Divider()
            DatePicker(selection: $newDate, in: Date()..., displayedComponents: .date) {
                Text("Select a date").withSimpleFont()
            }
            Divider()
            Button(action: {
                print(newDate)
                viewModel.changePredictedAmountDate(with: newDate)
                print(viewModel.predictedAmountDate)
                self.mode.wrappedValue.dismiss()
            }, label: {
                Text("Confirm")
                    .withSimpleFont()
            })
            Divider()
        }
        .inNavigationPageView(title: "Date settings")
        
        
    }
}

struct NavigationPageView: ViewModifier {
    let title: String
    func body(content: Content) -> some View {
        HStack(alignment: .top) {
            content
        }
        .navigationBarTitle(Text(title))
        .padding()
        .withAppBackground()
    }
}
