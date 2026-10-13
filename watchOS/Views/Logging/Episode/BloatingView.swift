////
////  BloatingView.swift
////
////  View to choose bloating status when logging an episode on the watch.
////
//import SwiftUI
//
//struct BloatingView: View {
//    @Binding var bloating: Bool
//    
//    @State private var hasSelected: Bool? = nil
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//
//            Text("Are you experiencing bloating?")
//                .font(.headline)
//
//            HStack(spacing: 12) {
//                Button {
//                    bloating = true
//                    hasSelected = true
//                } label: {
//                    Text("Yes")
//                        .frame(maxWidth: .infinity)
//                }
//                .buttonStyle(.borderedProminent)
//                .tint(hasSelected == true ? .red : .secondary)
//
//                Button {
//                    bloating = false
//                    hasSelected = false
//                } label: {
//                    Text("No")
//                        .frame(maxWidth: .infinity)
//                }
//                .buttonStyle(.borderedProminent)
//                .tint(hasSelected == false ? .green : .secondary)
//            }
//        }
//    }
//}
