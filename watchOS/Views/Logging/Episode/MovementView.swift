////
////  MovementView.swift
////
////  View to input most recent bowel movement on the watch.
////
//import SwiftUI
//
//struct MovementView: View {
//    @Binding var movement: Date
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text("When was your last bowel movement?")
//                .font(.headline)
//                .foregroundStyle(.primary)
//            
//            DatePicker("", selection: $movement, in: ...Date(),
//                       displayedComponents: [.hourAndMinute])
//                .labelsHidden()
//        }
//    }
//}
