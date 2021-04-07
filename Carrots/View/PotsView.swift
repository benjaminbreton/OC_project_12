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
            PotCell(pot: viewModel.commonPot)
                .frame(width: .none, height: CommonSettings().commonPotLineHeight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Divider().padding()
            Text("Athletics pots")
                .withBigTitleFont()
            if athleticsPots.count > 0 {
                ListBase(items: athleticsPots.map({
                                                    PotCell(pot: $0)
                                                        
                    
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
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Divider().padding()
                Text("""
                    The application provides, for each pot, an expected amount on a certain date if athletics keep adding performances on the same rythm.
                    
                    You can set this date here.
                    """).withSimpleFont()
                Divider().padding()
                DatePicker(selection: $newDate, in: Date()..., displayedComponents: .date) {
                    Text("Select a date").withSimpleFont()
                }
                Divider().padding()
                Button(action: {
                    print(newDate)
                    viewModel.changePredictedAmountDate(with: newDate)
                    print(viewModel.predictedAmountDate)
                    self.mode.wrappedValue.dismiss()
                }, label: {
                    Text("Confirm")
                        .withSimpleFont()
                })
                Divider().padding()
            }
        }
        .navigationBarTitle(Text("Date settings"))
        .padding()
        .withAppBackground()
    }
}
