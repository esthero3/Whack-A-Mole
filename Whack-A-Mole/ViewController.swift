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
    
    var timeCount = 0;
    
    func initTime() {
        var timeStampOne = NSDate().timeIntervalSince1970
    }
    
    
       
    
    
    var randomNumber = 0
    
    func updateRandomNumber() {
        
        initTime()
        
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
                
                var timeStampTwo = NSDate().timeIntervalSince1970
                
        
                
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
            
            
            //game run timer.
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){
                timer in
                self.timeCount += 1
                //print(self.timeCount)
                
                
                if self.timeCount == 20 {
                    timer.invalidate()
                    print("Time's up. Game Over")
                }
                
            }
            
      
            func getCurrentMillis()->Int64{
                return  Int64(NSDate().timeIntervalSince1970 * 1000)
            }

            


            
            //Timer to start game. Turns on first light.
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false){
                timer in
                self.updateRandomNumber()
            }
            
            
                   
            } catch {
                print(error)
            }
        }
    
    
    


}

