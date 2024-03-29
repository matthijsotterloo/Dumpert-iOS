//
//  VideoViewController.swift
//  Dumpview voor Dumpert.nl
//
//  Created by Joep4U on 16-12-15.
//  Copyright © 2015 Joep de Jong. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoViewController: UIViewController {
    @IBOutlet var videoView: UIView!
    @IBOutlet var kudos: UILabel!
    @IBOutlet var views: UILabel!
    @IBOutlet var name:  UILabel!
    @IBOutlet var brief:  UILabel!
    @IBOutlet var tags:  UILabel!
    @IBOutlet var date:  UILabel!
    @IBOutlet var kudosView: UIImageView!
    @IBOutlet var dumpview: UINavigationItem!
    
    //var openVideo = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        self.dumpview.title      = "DUMPVIEW"
        //self.dumpview.title        = UIColor(red: 102.0/255.0, green: 194.0/255.0, blue: 33.0/255.0, alpha: 1.0)
        //self.navigationController?.navigationBar.titleTextAttributes = attributes
        
        if let video = openVideo as? Video {
            let player = AVPlayer(URL: video.videoLink)
            let playerController = AVPlayerViewController()
            
            name?.text  = video.title.uppercaseString
            views.text  = video.views
            kudos.text  = video.kudos
            brief?.text = video.brief
            
            playerController.player = player
            self.addChildViewController(playerController)
            self.view.addSubview(playerController.view)
            playerController.view.frame = videoView.frame
            
            //Automatically play video
            player.play()

        }
        if(selectedVideo > -1){
            let video = videos[selectedVideo] as Video
            
            //let url = NSURL(string: "http://media.dumpert.nl/tablet/08cae0c3_Louis_Van_Gaal_X_Factor_audition.mp4.mp4.mp4")
            let player = AVPlayer(URL: video.videoLink)
            let playerController = AVPlayerViewController()
            
            name?.text  = video.title  //.uppercaseString
            views.text  = video.views
            kudos.text  = video.kudos
            kudosView.tintColor = UIColor(red: 255.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
            brief?.text = video.brief
            
            playerController.player = player
            self.addChildViewController(playerController)
            self.view.addSubview(playerController.view)
            playerController.view.frame = videoView.frame
            
            //Automatically play video
            player.play()
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
