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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set Dumpert logo in headaer
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .ScaleAspectFit
        imageView.image = UIImage(named: "Logo.png")
        self.navigationItem.titleView = imageView
        navigationController?.navigationBar.tintColor = UIColor(red: 110/256, green: 187/256, blue: 47/256, alpha: 1)
        
        if(selectedVideo > -1){
            let video = videos[selectedVideo] as Video
            
            //let url = NSURL(string: "http://media.dumpert.nl/tablet/08cae0c3_Louis_Van_Gaal_X_Factor_audition.mp4.mp4.mp4")
            let player = AVPlayer(URL: video.videoLink)
            let playerController = AVPlayerViewController()
            
            name?.text  = video.title
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
