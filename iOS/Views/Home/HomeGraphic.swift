//
//  HomeGraphic.swift
//
//  Holds the code to create the graphic on the home page.
//
import SwiftUI

struct HomeGraphicBack: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.92105*width, y: 0.5*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: 0.92105*height), control1: CGPoint(x: 0.92105*width, y: 0.73254*height), control2: CGPoint(x: 0.73254*width, y: 0.92105*height))
        path.addCurve(to: CGPoint(x: 0.07895*width, y: 0.5*height), control1: CGPoint(x: 0.26746*width, y: 0.92105*height), control2: CGPoint(x: 0.07895*width, y: 0.73254*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: 0.07895*height), control1: CGPoint(x: 0.07895*width, y: 0.26746*height), control2: CGPoint(x: 0.26746*width, y: 0.07895*height))
        path.addCurve(to: CGPoint(x: 0.92105*width, y: 0.5*height), control1: CGPoint(x: 0.73254*width, y: 0.07895*height), control2: CGPoint(x: 0.92105*width, y: 0.26746*height))
        path.closeSubpath()
        return path
    }
}

struct HomeGraphicMiddle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.3771*width, y: 0.25278*height))
        path.addCurve(to: CGPoint(x: 0.45549*width, y: 0.20839*height), control1: CGPoint(x: 0.41566*width, y: 0.22739*height), control2: CGPoint(x: 0.43494*width, y: 0.2147*height))
        path.addCurve(to: CGPoint(x: 0.54714*width, y: 0.20839*height), control1: CGPoint(x: 0.48521*width, y: 0.19926*height), control2: CGPoint(x: 0.51742*width, y: 0.19926*height))
        path.addCurve(to: CGPoint(x: 0.62553*width, y: 0.25278*height), control1: CGPoint(x: 0.56769*width, y: 0.2147*height), control2: CGPoint(x: 0.58697*width, y: 0.22739*height))
        path.addLine(to: CGPoint(x: 0.71224*width, y: 0.30986*height))
        path.addCurve(to: CGPoint(x: 0.75593*width, y: 0.34152*height), control1: CGPoint(x: 0.73514*width, y: 0.32494*height), control2: CGPoint(x: 0.74659*width, y: 0.33248*height))
        path.addCurve(to: CGPoint(x: 0.78632*width, y: 0.38696*height), control1: CGPoint(x: 0.76942*width, y: 0.3546*height), control2: CGPoint(x: 0.77976*width, y: 0.37008*height))
        path.addCurve(to: CGPoint(x: 0.79708*width, y: 0.4367*height), control1: CGPoint(x: 0.79085*width, y: 0.39865*height), control2: CGPoint(x: 0.79292*width, y: 0.41133*height))
        path.addLine(to: CGPoint(x: 0.81313*width, y: 0.53482*height))
        path.addCurve(to: CGPoint(x: 0.82038*width, y: 0.62164*height), control1: CGPoint(x: 0.82041*width, y: 0.57933*height), control2: CGPoint(x: 0.82406*width, y: 0.60159*height))
        path.addCurve(to: CGPoint(x: 0.77483*width, y: 0.6968*height), control1: CGPoint(x: 0.81506*width, y: 0.65066*height), control2: CGPoint(x: 0.799*width, y: 0.67717*height))
        path.addCurve(to: CGPoint(x: 0.69008*width, y: 0.73784*height), control1: CGPoint(x: 0.75812*width, y: 0.71037*height), control2: CGPoint(x: 0.73544*width, y: 0.71953*height))
        path.addLine(to: CGPoint(x: 0.58732*width, y: 0.77932*height))
        path.addCurve(to: CGPoint(x: 0.53219*width, y: 0.79872*height), control1: CGPoint(x: 0.55995*width, y: 0.79037*height), control2: CGPoint(x: 0.54626*width, y: 0.7959*height))
        path.addCurve(to: CGPoint(x: 0.47044*width, y: 0.79872*height), control1: CGPoint(x: 0.51185*width, y: 0.8028*height), control2: CGPoint(x: 0.49078*width, y: 0.8028*height))
        path.addCurve(to: CGPoint(x: 0.41531*width, y: 0.77932*height), control1: CGPoint(x: 0.45637*width, y: 0.7959*height), control2: CGPoint(x: 0.44268*width, y: 0.79037*height))
        path.addLine(to: CGPoint(x: 0.31255*width, y: 0.73784*height))
        path.addCurve(to: CGPoint(x: 0.2278*width, y: 0.6968*height), control1: CGPoint(x: 0.26719*width, y: 0.71953*height), control2: CGPoint(x: 0.24451*width, y: 0.71037*height))
        path.addCurve(to: CGPoint(x: 0.18225*width, y: 0.62164*height), control1: CGPoint(x: 0.20364*width, y: 0.67717*height), control2: CGPoint(x: 0.18757*width, y: 0.65066*height))
        path.addCurve(to: CGPoint(x: 0.1895*width, y: 0.53482*height), control1: CGPoint(x: 0.17858*width, y: 0.60159*height), control2: CGPoint(x: 0.18222*width, y: 0.57933*height))
        path.addLine(to: CGPoint(x: 0.20556*width, y: 0.4367*height))
        path.addCurve(to: CGPoint(x: 0.21632*width, y: 0.38696*height), control1: CGPoint(x: 0.20971*width, y: 0.41133*height), control2: CGPoint(x: 0.21178*width, y: 0.39865*height))
        path.addCurve(to: CGPoint(x: 0.2467*width, y: 0.34152*height), control1: CGPoint(x: 0.22287*width, y: 0.37008*height), control2: CGPoint(x: 0.23322*width, y: 0.3546*height))
        path.addCurve(to: CGPoint(x: 0.29039*width, y: 0.30986*height), control1: CGPoint(x: 0.25604*width, y: 0.33248*height), control2: CGPoint(x: 0.26749*width, y: 0.32494*height))
        path.addLine(to: CGPoint(x: 0.3771*width, y: 0.25278*height))
        path.closeSubpath()
        return path
    }
}

struct HomeGraphicFront: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.60131*width, y: 0.36832*height))
        path.addCurve(to: CGPoint(x: 0.68676*width, y: 0.5057*height), control1: CGPoint(x: 0.62979*width, y: 0.41412*height), control2: CGPoint(x: 0.68676*width, y: 0.5057*height))
        path.addCurve(to: CGPoint(x: 0.72381*width, y: 0.60011*height), control1: CGPoint(x: 0.68676*width, y: 0.5057*height), control2: CGPoint(x: 0.7232*width, y: 0.56547*height))
        path.addCurve(to: CGPoint(x: 0.66755*width, y: 0.68808*height), control1: CGPoint(x: 0.72446*width, y: 0.63808*height), control2: CGPoint(x: 0.70067*width, y: 0.67507*height))
        path.addCurve(to: CGPoint(x: 0.58355*width, y: 0.68717*height), control1: CGPoint(x: 0.64087*width, y: 0.69859*height), control2: CGPoint(x: 0.61118*width, y: 0.69423*height))
        path.addCurve(to: CGPoint(x: 0.49997*width, y: 0.6703*height), control1: CGPoint(x: 0.55588*width, y: 0.68007*height), control2: CGPoint(x: 0.5284*width, y: 0.6703*height))
        path.addCurve(to: CGPoint(x: 0.40239*width, y: 0.6905*height), control1: CGPoint(x: 0.46677*width, y: 0.67026*height), control2: CGPoint(x: 0.43494*width, y: 0.68348*height))
        path.addCurve(to: CGPoint(x: 0.30878*width, y: 0.67543*height), control1: CGPoint(x: 0.3727*width, y: 0.6969*height), control2: CGPoint(x: 0.33318*width, y: 0.69879*height))
        path.addCurve(to: CGPoint(x: 0.27719*width, y: 0.58534*height), control1: CGPoint(x: 0.28546*width, y: 0.6531*height), control2: CGPoint(x: 0.27231*width, y: 0.61891*height))
        path.addCurve(to: CGPoint(x: 0.31081*width, y: 0.50989*height), control1: CGPoint(x: 0.28123*width, y: 0.55755*height), control2: CGPoint(x: 0.29621*width, y: 0.53321*height))
        path.addCurve(to: CGPoint(x: 0.403*width, y: 0.36258*height), control1: CGPoint(x: 0.34152*width, y: 0.46076*height), control2: CGPoint(x: 0.37228*width, y: 0.41167*height))
        path.addCurve(to: CGPoint(x: 0.44077*width, y: 0.31114*height), control1: CGPoint(x: 0.41436*width, y: 0.34439*height), control2: CGPoint(x: 0.42591*width, y: 0.32604*height))
        path.addCurve(to: CGPoint(x: 0.49478*width, y: 0.28348*height), control1: CGPoint(x: 0.45564*width, y: 0.29624*height), control2: CGPoint(x: 0.47447*width, y: 0.28483*height))
        path.addCurve(to: CGPoint(x: 0.5579*width, y: 0.31012*height), control1: CGPoint(x: 0.51792*width, y: 0.28196*height), control2: CGPoint(x: 0.54048*width, y: 0.29361*height))
        path.addCurve(to: CGPoint(x: 0.60131*width, y: 0.36832*height), control1: CGPoint(x: 0.57532*width, y: 0.32658*height), control2: CGPoint(x: 0.58843*width, y: 0.34759*height))
        path.closeSubpath()
        return path
    }
}
