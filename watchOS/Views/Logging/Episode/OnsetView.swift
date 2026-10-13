////
////  OnsetView.swift
////
////  View to input symptom onset on the watch.
////
//import SwiftUI
//
//struct OnsetView: View {
//    @Binding var onset: Date
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text("When did your episode start?")
//                .font(.headline)
//                .foregroundStyle(.primary)
//            
//            DatePicker("", selection: $onset, in: ...Date(),
//                       displayedComponents: [.hourAndMinute])
//                .labelsHidden()
//        }
//    }
//}
