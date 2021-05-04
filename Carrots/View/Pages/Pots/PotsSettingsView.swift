//
//  PotsSettingsView.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI
struct PotsSettingsView: View {
    let viewModel: FakeViewModel
    @State var date: Date
    @State var pointsForOneEuro: String
    
    var body: some View {
        VStack() {
            SettingsDatePicker(title: "Prevision date", date: $date, range: .afterToday, explanations: """
                                The application provides, for each pot, an expected amount on a certain date if athletics keep adding performances on the same rythm.
                                
                                You can set this date here.
                                """)
            SettingsTextfield(title: "Points for one euro", placeHolder: "Points", value: $pointsForOneEuro, keyboard: .numberPad, explanations: """
In this application, athletics can earn points by doing some sports performances.
Points can be converted in euros in each pot.
Set here the necessary number of points to earn one euro.
""")
            /*
             Divider()
             Text("""
             The application provides, for each pot, an expected amount on a certain date if athletics keep adding performances on the same rythm.
             
             You can set this date here.
             """)
             .withSimpleFont()
             .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
             .layoutPriority(1)
             Divider()
             DatePicker(selection: $date, in: Date()..., displayedComponents: .date) {
             Text("Select a date").withSimpleFont()
             }
             ConfirmButton {
             
             }
             */
        }
        .inSettingsPage("general settings") {
            
        }
        
        
    }
}
