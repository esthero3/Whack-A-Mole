//
//  ViewController.swift
//  Whack-A-Mole
//
//  Created by Esther Osammor on 2019-11-22.
//  Copyright © 2019 Esther Osammor. All rights reserved.
//

import UIKit
import Phidget22Swift

class ViewController: UIViewController {
    
    //create objects
       let redButton = DigitalInput()
       let greenButton = DigitalInput()
       let redLED = DigitalOutput()
       let greenLED = DigitalOutput()
       
       //handlers
       func redButtonAttach(sender: Phidget){
           print("Red Button Attached")
       }

       func greenButtonAttach(sender: Phidget){
           print("Green Button Attached")
       }

       func redLEDAttach(sender: Phidget){
           print("Red LED Attached")
       }

       func greenLEDAttach(sender: Phidget){
           print("Green LED Attached")
       }
    
    
    var randomNumber = 0
    
    func updateRandomNumber() {
        
        randomNumber = Int(arc4random_uniform(2))
        print(randomNumber)
        
        do{
        if randomNumber == 0 {
            print("red light on")
            try redLED.setState(true)
        } else {
            print("green light on")
            try greenLED.setState(true)
        }
            } catch {
            print(error)
        }
    }
    
    
    
    //statechange
    //red
    func redButtonStateChange(sender: Phidget, state:Bool) {
        do {
            if(state) {
               //print("down")
                if randomNumber == 0 {
                print("light will turn off")
                    try redLED.setState(false)
                    updateRandomNumber()
                } else {
                    print("wrong!")
                }
                
                
            } else {
                
                
            }
        } catch {
            print(error)
        }
    }
    
    //green
    func greenButtonStateChange(sender: Phidget, state:Bool) {
        do {
            if(state) {
                //print("down")
                if randomNumber != 0 {
                    print("green light will turn off")
                    try greenLED.setState(false)
                    updateRandomNumber()
                } else {
                    print("wrong!")
                }
                
            } else {
                               
            }
        } catch {
            print(error)
        }
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        do {
                //server discovery
                try Net.enableServerDiscovery(serverType: .deviceRemote)
                
                //adressing objects
                try redButton.setDeviceSerialNumber(528304)
                try redButton.setHubPort(1)
                try redButton.setIsHubPortDevice(true)
                
                try greenButton.setDeviceSerialNumber(528304)
                try greenButton.setHubPort(0)
                try greenButton.setIsHubPortDevice(true)
                
                try redLED.setDeviceSerialNumber(528304)
                try redLED.setHubPort(3)
                try redLED.setIsHubPortDevice(true)
                
                try greenLED.setDeviceSerialNumber(528304)
                try greenLED.setHubPort(2)
                try greenLED.setIsHubPortDevice(true)
                
                //event handlers
                let _ = redButton.attach.addHandler(redButtonAttach)
                let _ = redButton.stateChange.addHandler(redButtonStateChange)

                let _ = greenButton.attach.addHandler(greenButtonAttach)
                let _ = greenButton.stateChange.addHandler(greenButtonStateChange)

                let _ = redLED.attach.addHandler(redLEDAttach)

                let _ = greenLED.attach.addHandler(greenLEDAttach)
                
                //open objects
                try redButton.open()
                try greenButton.open()
                try redLED.open()
                try greenLED.open()
            
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false){
                timer in
                self.updateRandomNumber()
            }
            
            func updateTime() {
                
            }
                
                
            } catch {
                print(error)
            }
        }
    
    
    


}

