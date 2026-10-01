//
//  ParallaxImage.swift
//  MSParallexScroll
//
//  Created by Mohit Sharma on 01/10/26.
//

import SwiftUI
import UIKit

// Default is amount 0.35 and both directions.
// UIKit: imageView.amount = 0.5
//        imageView.axis = .horizontal
// SwiftUI: .parallax(amount: 0.5, axis: .vertical)

public enum ParallaxAxis: Sendable {
    case horizontal
    case vertical
    case both
}

public final class ParallaxImageView: UIImageView {
    public var amount: CGFloat = 0.35 {
        didSet { applyOffset() }
    }

    public var axis: ParallaxAxis = .both {
        didSet { applyOffset() }
    }

    private var observation: NSKeyValueObservation?

    public override func didMoveToWindow() {
        super.didMoveToWindow()
        clipsToBounds = false
        contentMode = .scaleAspectFill
        observation = nearestScrollView()?.observe(\.contentOffset) { [weak self] _, _ in
            self?.applyOffset()
        }
        applyOffset()
    }

    private func applyOffset() {
        guard let window else {
            return
        }
        let frame = convert(bounds, to: window)
        let shift = parallaxShift(
            midX: window.bounds.midX,
            midY: window.bounds.midY,
            frame: frame,
            amount: amount,
            axis: axis
        )
        transform = CGAffineTransform(translationX: shift.x, y: shift.y).scaledBy(x: 1.60, y: 1.60)
    }

    private func nearestScrollView() -> UIScrollView? {
        var view = superview
        while let current = view, !(current is UIScrollView) {
            view = current.superview
        }
        return view as? UIScrollView
    }
}

public extension View {
    @ViewBuilder
    func parallax(amount: CGFloat = 0.35, axis: ParallaxAxis = .both) -> some View {
        if #available(iOS 17.0, *) {
            let midX = UIScreen.main.bounds.midX
            let midY = UIScreen.main.bounds.midY
            visualEffect { effect, proxy in
                let frame = proxy.frame(in: .global)
                let shift = parallaxShift(midX: midX, midY: midY, frame: frame, amount: amount, axis: axis)
                return effect.scaleEffect(1.60).offset(x: shift.x, y: shift.y)
            }
            .clipped()
        } else {
            self
        }
    }
}

private func parallaxShift(
    midX: CGFloat,
    midY: CGFloat,
    frame: CGRect,
    amount: CGFloat,
    axis: ParallaxAxis
) -> CGPoint {
    let x = axis == .vertical ? 0 : (midX - frame.midX) * amount
    let y = axis == .horizontal ? 0 : (midY - frame.midY) * amount
    return CGPoint(x: x, y: y)
}
