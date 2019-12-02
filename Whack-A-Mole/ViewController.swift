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
    
    //global variables
    var timeCount = 0;
    var randomNumber = 0
    
    var timeStampOne = NSDate().timeIntervalSince1970
    var timeStampTwo = NSDate().timeIntervalSince1970
    
    var finalNumber = Double(0)
    var finalSum = [Double]()
    
    
    
    //function to get a random number.
    func updateRandomNumber() {
        
        //time when a random number is generated
        timeStampOne = NSDate().timeIntervalSince1970
        
       
        //gets a random number between 0 and 1
        randomNumber = Int(arc4random_uniform(2))
        
        //if the number is 0, the red led will turn on. if the number is 1, green led will turn on
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
            
            //when red button is pressed
            if(state) {
                
                //time when button is pressed
                timeStampTwo = NSDate().timeIntervalSince1970

                //gets the difference between time of when number is generated and when button is pressed
                finalNumber = Double(timeStampTwo - timeStampOne)
                print(finalNumber)
                
                //puts all the time differences in an array
                finalSum.append(finalNumber)
                                
        
                //turn off the light and allows a new number to be generated
                if randomNumber == 0 {
                //print("light will turn off")
                    try redLED.setState(false)
                    updateRandomNumber()
                    
                //pressing the red button when the green led is on
                } else {
                    print("wrong!")
                }
            //when button is not pressed
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
                
                //time when button is pressed
                timeStampTwo = NSDate().timeIntervalSince1970
                 
                //gets the difference between time of when number is generated and when button is pressed
                finalNumber = Double(timeStampTwo - timeStampOne)
                 print(finalNumber)
                
                //puts all the time differences in an array
                finalSum.append(finalNumber)
                
                //turn off the light and allows a new number to be generated
                if randomNumber != 0 {
                    //print("green light will turn off")
                    try greenLED.setState(false)
                    updateRandomNumber()
                    
                //pressing the green button when the red led is on
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
                
                //stops game after 20 seconds
                if self.timeCount == 20 {
                    timer.invalidate()
                    
                    do {
                        try self.redLED.setState(false)
                        try self.greenLED.setState(false)
                    } catch {
                        print(error)
                    }
                    
                    //sum of the time to press buttons
                    let sum = self.finalSum.reduce(0, +)
                    
                    print("Time's up. Game Over")
                    print("final score \(sum)")
                }
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

