//
//  CalendarUIKitView.swift
//  AheadAche
//
//  UIKitView representation for the Calendar object, which allows for date-based decorations.
//
//  Created by Franklin Rigoutsos on 2/16/26.
//
import SwiftUI
import UIKit

struct CalendarUIKitView: UIViewRepresentable {
    
    @Binding var selectedDate: Date
    var headacheDays: Set<Date>
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        calendarView.delegate = context.coordinator
        calendarView.selectionBehavior = UICalendarSelectionSingleDate(delegate: context.coordinator)
        
        calendarView.setContentHuggingPriority(.required, for: .vertical)
        calendarView.setContentCompressionResistancePriority(.required, for: .vertical)
        
        return calendarView
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        context.coordinator.parent = self
        
        /*
         * When we re-render this view, we want to get the list of headache days to update the decorations.
         * This is mainly for going back to the calendar view after logging a new headache.
         */
        let calendar = Calendar.current
        let components = headacheDays.map {
            calendar.dateComponents([.year, .month, .day], from: $0)
        }
        
        uiView.reloadDecorations(forDateComponents: components, animated: true)
    }
    
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UICalendarView, context: Context) -> CGSize? {
        let width = proposal.width ?? UIView.layoutFittingExpandedSize.width
        let fitting = uiView.sizeThatFits(CGSize(width: width, height: UIView.layoutFittingCompressedSize.height))
        return CGSize(width: width, height: fitting.height)
    }
    
    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        var parent: CalendarUIKitView
        
        init(_ parent: CalendarUIKitView) {
            self.parent = parent
        }
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            guard let components = dateComponents,
                  let date = Calendar.current.date(from: components) else { return }
            
            parent.selectedDate = date
        }
        
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            guard let date = Calendar.current.date(from: dateComponents) else { return nil }
            
            let startOfDay = Calendar.current.startOfDay(for: date)
            
            // TODO: we do not update the red dots after adding the headache!
            if parent.headacheDays.contains(startOfDay) {
                return .default(color: .systemRed, size: .large)
            }
            
            return nil
        }
    }
}
