//
//  ViewController.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 5. 30..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let study = kuStudy()
        study.setAuthentification("kustudy", password: "leid*Eat.Oc:koR.I^Ho")
        study.requestSummary { (json, error) -> Void in
            println(json)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

