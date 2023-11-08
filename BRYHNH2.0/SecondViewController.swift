//
//  SecondViewController.swift
//  BRYHNH
//
//  Created by Bill Skrzypczak on 9/20/18.
//  Copyright © 2018 Bill Skrzypczak. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


class SecondViewController: UIViewController {

    
    // Create a variable in which to pass the songlist and stream url
    var currentList: String!
    var mystream: String!
    
    
    // Create a outlet to capyure the songlist text
    @IBOutlet weak var songList: UITextView!
    
    @IBAction func startEpisode(_ sender: Any) {
        // Load the audio stream into AVPlayer
        // print("The stream is -->  ",mystream)
        
        
        // Set the stream to the selected show
        let url = URL(string:mystream)
        let player = AVPlayer(url: url!)
        
       
        // Launch the audio in AVPlayer
        let controller = AVPlayerViewController()
        controller.player = player
        present(controller, animated: true) {
            player.play()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Change the color of the back button text
        //
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        //Load the songlist into the textView
        //print(currentList)
        songList.text = currentList
        
        // Setup player to continue playing when home
        // button is pressed
        
        let session = AVAudioSession.sharedInstance()
        
        do
        {
            try session.setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default)
        }
        catch{
            
        }
        
        
//
        
        
       
        
    }
    
    
   
}
