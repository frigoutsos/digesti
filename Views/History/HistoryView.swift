//
//  HistoryView.swift
//  AheadAche
//
//  This view displays the user's headaches as a scrollable list.
//
//  Created by Franklin Rigoutsos on 2/1/26.
//
import SwiftUI
import SwiftData

struct HistoryView: View {
    // Get a list of headaches, reverse sorted by time
    @Query(sort: \Headache.onsetDateAndTime, order: .reverse) private var headaches: [Headache]
    
    // Access the configured model context
    @Environment(\.modelContext) private var modelContext
    
    // State to track selected headache being viewed, if any
    @State private var selectedHeadache: Headache? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                // If there are no headaches, inform the user
                if (headaches.isEmpty) {
                    Text("No headaches to display.")
                        .foregroundStyle(.secondary)
                // Otherwise, display all the headaches in a list
                } else {
                    List {
                        ForEach(headaches) { headache in
                            VStack(alignment: .leading) {
                                Text(headache.onsetDateAndTime.formatted(date: .abbreviated, time: .shortened))
                                    .font(.headline)
                                Text("Intensity: \(headache.intensity) / 10")
                                    .font(.subheadline)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                            // Set the selected headache state when clicking a headache
                            .onTapGesture {
                                selectedHeadache = headache
                            }
                        }
                        .onDelete(perform: deleteItem)
                    }
                    // A sheet will popup when the user clicks a headache
                    .sheet(item: $selectedHeadache) { headache in
                        NavigationStack {
                            // Allow scrolling through summary view for those using larger text sizes
                            ScrollView {
                                VStack(spacing: 16) {
                                    HeadacheView(headacheToView: headache)
                                        .padding()
                                        .frame(maxWidth: 400)
                                        .background(
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(Color(.secondarySystemGroupedBackground))
                                                .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
                                        )
                                }
                                .padding()
                            }
                            .background(Color(.systemGroupedBackground))
                            .navigationTitle("Headache Summary")
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .topBarTrailing) {
                                    Button("Close", role: .close) {
                                        selectedHeadache = nil
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("History")
        }
    }
    
    /*
     * Function to delete a headache from the list and the SwiftData model.
     */
    func deleteItem(at offsets: IndexSet) {
        for index in offsets {
            let item = headaches[index]
            modelContext.delete(item)
        }
        
        try? modelContext.save()
    }
}

#Preview {
    HistoryView()
}
