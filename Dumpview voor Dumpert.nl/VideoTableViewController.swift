//
//  VideoTableViewController.swift
//  Dumpview voor Dumpert.nl
//
//  Created by Joep4U on 13-12-15.
//  Copyright © 2015 Joep de Jong. All rights reserved.
//

import UIKit
import Foundation

var selectedVideo: Int = 0
var videos = [Video]()
let videoAmount: Int = 10


class VideoTableViewController: UITableViewController {
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "VideoTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "video")
        tableView.rowHeight = 120
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        //Parse 30 new video's
        print(DumpertApi.getRecentVideos(videoAmount))
        parseVideoXml(DumpertApi.getXML(DumpertApi.getRecentVideos(videoAmount))!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return videos.count
        //return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: VideoTableViewCell = tableView.dequeueReusableCellWithIdentifier("video", forIndexPath: indexPath) as! VideoTableViewCell
        let video = videos[indexPath.row]
        
        //cell.textLabel?.text = video.title
        //cell.imageView?.image = video.thumb
        cell.thumb?.image = video.thumb
        cell.title?.text = video.title.uppercaseString
        
        cell.views?.text = video.views
        cell.kudos?.text = video.kudos
        
        // Change color for kudos
        if video.kudos.rangeOfString("-") != nil {
            cell.kudos?.textColor = UIColor.redColor()
        } else {
            cell.kudos?.textColor = UIColor(red: 110/256, green: 187/256, blue: 47/256, alpha: 1)
        }
        
        // Set font family for cells
        cell.title?.font = UIFont(name: "AvenirNextLTPro-Bold", size: 15)!
        cell.kudos?.font = UIFont(name: "AvenirNextLTPro-Bold", size: 13)!
        cell.views?.font = UIFont(name: "AvenirNextLTPro-Bold", size: 13)!
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if(videos.count >= videoAmount - 1){
            let lastRowIndex: Int = tableView.numberOfRowsInSection(0) - 1
            if (indexPath.row == lastRowIndex) {
                // This is the last cell
                let video = videos[indexPath.row]

                print(video.id)
                parseVideoXml(DumpertApi.getXML(DumpertApi.getRecentVideos(String(video.id)))!)
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("videoSegue", sender: self)
        
    }

    func parseVideoXml(data: NSData){

        let xml = SWXMLHash.parse(data)

        //var videos = [Video]()
        
        for video in xml["videos"]["video"] {
            //print(video["thumb"].element!.text!)
            
            if(!video["nsfw"]){
                Image.downloadImage(NSURL(string: video["thumb"].element!.text!)!, completion: { (image) -> Void in
                    
                    let id = video["id"].element!.text!
                    let thumb = image
                    let title = video["title"].element!.text!
                    let brief = video["brief"].element!.text!
                    let date = video["date"].element!.text!
                    let videoLinkLow = NSURL(string: video["videoLinkLow"].element!.text!)
                    let videoLink = NSURL(string: video["videoLink"].element!.text!)
                    
                    var tags = ""
                    
                    if(video["tags"]){
                        tags = video["tags"].element!.text!
                    }
                    
                    var views = video["views"].element!.text!
                    let kudos = video["kudos"].element!.text!
                    
                    // If more then 1.000 views switch to K.
                    if(Double(views) >= 10000){
                        views = String(round(Double(views)!/1000.0)/10.0) + "K"
                    }
                    
                    videos.append(Video(id: id, thumb: thumb!, title: title, brief: brief, date: date, videoLinkLow: videoLinkLow!, videoLink: videoLink!, tags: tags, views: views, kudos: kudos))
                    videos.sort { $0.id < $1.id }
                    self.tableView.reloadData()
                })
            }
            
        }
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "videoSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            
            selectedVideo = indexPath!.row
            
            tableView.deselectRowAtIndexPath(indexPath!, animated: true)
            
            //Custom back button text
            let backItem = UIBarButtonItem()
            backItem.title = "Video's"
            //backItem.
            
            self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()            
            navigationItem.backBarButtonItem = backItem
            
            
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let nav = self.navigationController?.navigationBar
        let attributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "AvenirNextLTPro-Bold", size: 30)!
        ]
        
        nav?.topItem?.title      = "DUMPVIEW"
        nav?.barTintColor        = UIColor(red: 103.0/255.0, green: 193.0/255.0, blue: 33.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = attributes
    }
}
