//
//  Utils.swift
//  ElasticViewTest
//
//  Created by Shuchen Du on 2016/03/17.
//  Copyright © 2016年 Shuchen Du. All rights reserved.
//

import UIKit

extension UIView {
    
    func getViewCenter(animating: Bool) -> CGPoint {
        
        if animating, let presentationLayer = layer.presentationLayer() as? CALayer {
            
            return presentationLayer.position
            
        } else {
            
            return center
        }
    }
    
}

func errorMessageString(msg: String) {
    
    print("-------------[\(msg)]")
}

func errorMessageFloat(msg: CGFloat) {
    
    print("-------------[\(msg)]")
}