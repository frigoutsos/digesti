//
//  BristolStoolView.swift
//
//  Created by Franklin Rigoutsos on 6/8/26.
//
import SwiftUI

struct BristolStoolView: View {
    let type: BristolStoolType

    var body: some View {
        ZStack {
            switch type {

            // 1: Separate hard lumps, like nuts
            case .type1:
                HStack(spacing: 6) {
                    ForEach(0..<4) { i in
                        Circle()
                            .fill(Color.accent)
                            .frame(width: 9 + CGFloat(i % 2), height: 9 + CGFloat(i % 2))
                            .opacity(0.8 + Double(i % 2) * 0.2)
                    }
                }

            // 2: Lumpy sausage (knobbly)
            case .type2:
                Canvas { context, size in
                    // Main sausage body with integrated lumps
                    var mainPath = Path()
                    mainPath.move(to: CGPoint(x: 10, y: 20))
                    mainPath.addCurve(
                        to: CGPoint(x: 65, y: 20),
                        control1: CGPoint(x: 25, y: 8),
                        control2: CGPoint(x: 50, y: 8)
                    )
                    mainPath.addCurve(
                        to: CGPoint(x: 10, y: 20),
                        control1: CGPoint(x: 50, y: 32),
                        control2: CGPoint(x: 25, y: 32)
                    )
                    context.fill(mainPath, with: .color(.accent.opacity(0.85)))
                    
                    // Add prominent lumps with varying sizes
                    let lumpPositions: [(CGFloat, CGFloat, CGFloat)] = [
                        (15, 20, 8),    // x, y, size
                        (28, 16, 9),
                        (40, 22, 7),
                        (52, 15, 9),
                        (63, 19, 8)
                    ]
                    
                    for (x, y, size) in lumpPositions {
                        var lumpPath = Path()
                        lumpPath.addEllipse(in: CGRect(x: x - size/2, y: y - size/2, width: size, height: size + 4))
                        context.fill(lumpPath, with: .color(.accent))
                    }
                    
                    // Add subtle shadows under lumps for depth
                    for (x, y, size) in lumpPositions {
                        var shadowPath = Path()
                        shadowPath.addEllipse(in: CGRect(x: x - size/2 + 1, y: y + size/2, width: size - 2, height: 3))
                        context.fill(shadowPath, with: .color(.accent.opacity(0.4)))
                    }
                }


            // 3: Sausage-shaped with surface cracks
            case .type3:
                ZStack {
                    // Main sausage body
                    Capsule()
                        .fill(Color.accent)
                        .frame(width: 70, height: 24)
                    
                    // Cracks on surface
                    VStack(spacing: 0) {
                        HStack(spacing: 12) {
                            ForEach(0..<4) { _ in
                                Rectangle()
                                    .fill(Color.black.opacity(0.2))
                                    .frame(width: 1.5, height: 10)
                            }
                        }
                        .padding(.horizontal, 8)
                    }
                }

            // 4: Smooth sausage (ideal/normal)
            case .type4:
                Capsule()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.accent,
                                Color.accent.opacity(0.85)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 75, height: 26)
                    .shadow(color: .accent.opacity(0.3), radius: 3, x: 0, y: 1)

            // 5: Soft blobs with clear-cut edges
            case .type5:
                HStack(spacing: 5) {
                    ForEach(0..<3) { i in
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.accent.opacity(0.85))
                            .frame(width: 16, height: 18)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.accent.opacity(0.3), lineWidth: 0.5)
                            )
                    }
                }

            // 6: Fluffy pieces, mushy consistency
            case .type6:
                HStack(spacing: 3) {
                    ForEach(0..<5) { i in
                        let heights: [CGFloat] = [12, 15, 18, 15, 12]
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.accent.opacity(0.75))
                            .frame(width: 10, height: heights[i])
                    }
                }

            // 7: Liquid or mushy, no form
            case .type7:
                Canvas { context, size in
                    // Create a watery splash appearance
                    for i in 0..<8 {
                        let angle = CGFloat(i) * (.pi * 2 / 8)
                        let x = 40 + 15 * cos(angle)
                        let y = 20 + 12 * sin(angle)
                        
                        var drip = Path()
                        drip.addEllipse(in: CGRect(x: x - 4, y: y - 5, width: 8, height: 10))
                        context.fill(drip, with: .color(.accent.opacity(0.7)))
                    }
                    
                    // Center pool
                    var center = Path()
                    center.addEllipse(in: CGRect(x: 32, y: 15, width: 16, height: 10))
                    context.fill(center, with: .color(.accent.opacity(0.8)))
                }
            }
        }
        .frame(height: 50)
    }
}
