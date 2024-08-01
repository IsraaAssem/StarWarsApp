//
//  LottieBackgroundView.swift
//  StarWarsApp
//
//  Created by Israa Assem on 01/08/2024.
//

import Foundation
import Lottie
func getBackgroundView(lottieName:String,viewName:UIView)->UIView{
    let lottieView=LottieAnimationView(name:lottieName )
    let backgroundView = UIView(frame: viewName.bounds)
    lottieView.contentMode = .scaleAspectFit
    lottieView.frame.size=CGSize(width: viewName.frame.width/2, height: viewName.frame.width/2)
    lottieView.center=viewName.center
    backgroundView.addSubview(lottieView)
    lottieView.play()
    lottieView.loopMode = .loop
    return backgroundView
}
