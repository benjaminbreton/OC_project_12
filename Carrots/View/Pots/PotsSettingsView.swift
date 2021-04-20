//
//  PotsSettingsView.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI
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
                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                .layoutPriority(1)
            Divider()
            DatePicker(selection: $newDate, in: Date()..., displayedComponents: .date) {
                Text("Select a date").withSimpleFont()
            }
            ConfirmButton {
                print(newDate)
                viewModel.changePredictedAmountDate(with: newDate)
                print(viewModel.predictedAmountDate)
                self.mode.wrappedValue.dismiss()
            }
        }
        .inNavigationPageView(title: "Date settings")
        
        
    }
}
struct PotSettingsCell: View {
    var body: some View {
        VStack {
            
        }
    }
}

struct AppSettings: View {
    @State var date: Date
    @State var points: String
    var body: some View {
        VStack {
            CustomDatePicker(date: $date)
            CustomTextfield(title: "Points for one euro", placeHolder: "Points", value: $points, keyboard: .numberPad)
        }
        .inSettingsPage("app settings") {
            
        }
    }
}
struct CustomDatePicker: View {
    @Binding var date: Date
    var body: some View {
        VStack {
            Text("Date settings")
                .withTitleFont()
            VStack {
                Text("""
                                    The application provides, for each pot, an expected amount on a certain date if athletics keep adding performances on the same rythm.
                                    
                                    You can set this date here.
                                    """)
                    .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                DatePicker(selection: _date, in: Date()..., displayedComponents: .date) {
                    Text("Select a date")
                }
            }
            .withSimpleFont()
            .inRectangle(.center)
        }
    }
}
