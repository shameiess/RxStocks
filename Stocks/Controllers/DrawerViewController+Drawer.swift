//
//  DrawerViewController+Drawer.swift
//  Stocks
//
//  Created by Kevin Nguyen on 1/9/19.
//  Copyright © 2019 Kevin Nguyen. All rights reserved.
//

import UIKit

extension DrawerViewController {
    
    func setupDrawer() {
        view.addSubview(momentumView)
        momentumView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        momentumView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        momentumView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 80).isActive = true
        momentumView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
        
        momentumView.addSubview(handleView)
        handleView.topAnchor.constraint(equalTo: momentumView.topAnchor, constant: 10).isActive = true
        handleView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        handleView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        handleView.centerXAnchor.constraint(equalTo: momentumView.centerXAnchor).isActive = true
        
        closedTransform = CGAffineTransform(translationX: 0, y: view.bounds.height * 0.5)
        fullyClosedTransform = CGAffineTransform(translationX: 0, y: view.bounds.height)
        momentumView.transform = closedTransform
        
        panRecognizer.addTarget(self, action: #selector(panned))
        panRecognizer.delegate = self
        momentumView.addGestureRecognizer(panRecognizer)
    }
    
    @objc func panned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startAnimationIfNeeded()
            animator.pauseAnimation()
            animationProgress = animator.fractionComplete
        case .changed:
            var fraction = -recognizer.translation(in: momentumView).y / closedTransform.ty
            if isOpen { fraction *= -1 }
//            if isFullyClosed { fraction *= -1 }
            if animator.isReversed {
                fraction *= -1
            }
            if fraction < 0 {
                animator.addAnimations {
                    self.momentumView.transform = self.fullyClosedTransform
                }
            }
            animator.fractionComplete = abs(fraction + animationProgress)
            print("isOpen: \(isOpen), isFullyClosed: \(isFullyClosed), fraction: \(fraction), animator.fractionComplete: \(animator.fractionComplete)")
        // todo: rubberbanding
        case .ended, .cancelled:
            let yVelocity = recognizer.velocity(in: momentumView).y
            let shouldClose = yVelocity > 0 // todo: should use projection instead
            if yVelocity == 0 {
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                break
            }
            
//            print("isOpen: \(isOpen)\n isFullyClosed: \(isFullyClosed)\n shouldClose: \(shouldClose)\n animator.isReversed: \(animator.isReversed)\n transform: \(momentumView.transform)")

            if isOpen {
                if !shouldClose && !animator.isReversed {
                    animator.isReversed.toggle()
                }
                if shouldClose && animator.isReversed {
                    animator.isReversed.toggle()
                }
            } else {
                if shouldClose && !animator.isReversed {
//                    animator.addAnimations {
////                        if self.isFullyClosed {
//                            self.momentumView.transform = self.fullyClosedTransform
////                        }
//                    }
                }
                if !shouldClose && animator.isReversed {
                    animator.isReversed.toggle()
                }
            }
            
//            if isFullyClosed {
////                if shouldClose && animator.isReversed { animator.isReversed.toggle() }
//            }
            
//            print("yVelocity: \(yVelocity), shouldClose: \(shouldClose), isOpen: \(isOpen)")
            let fractionRemaining = 1 - animator.fractionComplete
            var distanceRemaining = fractionRemaining * closedTransform.ty
            if self.momentumView.transform == self.fullyClosedTransform {
                distanceRemaining = fractionRemaining * fullyClosedTransform.ty
            }

            if distanceRemaining == 0 {
//                animator.addAnimations {
//                    self.momentumView.transform = self.fullyClosedTransform
//                }
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                break
            }
            let relativeVelocity = min(abs(yVelocity) / distanceRemaining, 30)
            let timingParameters = UISpringTimingParameters(damping: 0.8, response: 0.3, initialVelocity: CGVector(dx: relativeVelocity, dy: relativeVelocity))
            let preferredDuration = UIViewPropertyAnimator(duration: 0, timingParameters: timingParameters).duration
            let durationFactor = CGFloat(preferredDuration / animator.duration)
            animator.continueAnimation(withTimingParameters: timingParameters, durationFactor: durationFactor)
        default: break
        }
    }
    
    func startAnimationIfNeeded() {
        if animator.isRunning { return }
        let timingParameters = UISpringTimingParameters(damping: 1, response: 0.4)
        animator = UIViewPropertyAnimator(duration: 0, timingParameters: timingParameters)
//        if self.isFullyClosed {
//            animator.addAnimations {
//                self.momentumView.transform = self.fullyClosedTransform
//            }
//        } else {
        animator.addAnimations {
            self.momentumView.transform = self.isOpen ? self.closedTransform : .identity
//            self.momentumView.transform = self.isFullyClosed ? self.fullyClosedTransform : .identity
//            if self.isFullyClosed {
//                self.momentumView.transform = self.fullyClosedTransform
//            }
        }
        animator.addCompletion { position in
            if position == .end {
                self.isOpen.toggle()
//                self.isFullyClosed = self.isOpen ? false : true
            }
        }
//        }
        animator.startAnimation()
    }
    
    @objc func fireTimer() {
        momentumView.topColor = UIColor.random()
        momentumView.bottomColor = UIColor.random()
    }
}

class InstantPanGestureRecognizer: UIPanGestureRecognizer {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        self.state = .began
    }
}
