//
//  HealthInsightCardSupport.swift
//
import SwiftUI

// Least-squares trend line endpoints for a set of HealthEpisodePairs
struct TrendLineInfo {
    let xMin: Double
    let xMax: Double
    let slope: Double
    let intercept: Double
    func yAt(_ x: Double) -> Double { (slope * x + intercept).clamped(to: 0...10) }
}

func trendLine(pairs: [HealthEpisodePair]) -> TrendLineInfo? {
    guard pairs.count >= 2 else { return nil }
    let xs = pairs.map { $0.healthValue }
    let ys = pairs.map { Double($0.episode.intensity) }
    let n  = Double(pairs.count)
    let sx  = xs.reduce(0,+);  let sy  = ys.reduce(0,+)
    let sxy = zip(xs,ys).map(*).reduce(0,+)
    let sx2 = xs.map { $0*$0 }.reduce(0,+)
    let d   = n * sx2 - sx * sx
    guard d != 0 else { return nil }
    let slope = (n * sxy - sx * sy) / d
    let inter = (sy - slope * sx) / n
    return TrendLineInfo(xMin: xs.min()!, xMax: xs.max()!, slope: slope, intercept: inter)
}

extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
