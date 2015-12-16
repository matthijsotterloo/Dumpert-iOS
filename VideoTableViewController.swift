//
//  VideoTableViewController.swift
//  Dumpview voor Dumpert.nl
//
//  Created by Joep4U on 13-12-15.
//  Copyright © 2015 Joep de Jong. All rights reserved.
//

import UIKit

var selectedVideo: Int = 0
var videos = [Video]()


class VideoTableViewController: UITableViewController {
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(DumpertApi.getRecentVideos(10))
        parseVideoXml(DumpertApi.getXML(DumpertApi.getRecentVideos(15))!)
        self.tableView.reloadData()
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("video", forIndexPath: indexPath)
        let video = videos[indexPath.row]
        
        cell.textLabel?.text = video.title
        cell.imageView?.image = video.thumb
        //cell.textLabel?.text = "test"
        
        return cell
    }
    
    func parseVideoXml(data: NSData){
        
        let xml = SWXMLHash.parse(data)
        
        //var videos = [Video]()
        
        for video in xml["videos"]["video"] {
            //print(video["thumb"].element!.text!)
            Image.downloadImage(NSURL(string: video["thumb"].element!.text!)!, completion: { (image) -> Void in
                
                let id = video["id"].element!.text!
                let thumb = image
                let title = video["title"].element!.text!
                let brief = video["brief"].element!.text!
                let date = video["date"].element!.text!
                let videoLinkLow = NSURL(string: video["videoLinkLow"].element!.text!)
                let videoLink = NSURL(string: video["videoLink"].element!.text!)
                let tags = video["tags"].element!.text!
                let views = Int(video["views"].element!.text!)!
                let kudos = Int(video["kudos"].element!.text!)!
                //print(id)
                
                videos.append(Video(id: id, thumb: thumb!, title: title, brief: brief, date: date, videoLinkLow: videoLinkLow!, videoLink: videoLink!, tags: tags, views: views, kudos: kudos))
                self.tableView.reloadData()
                //print(self.videos.count)
            })
            
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
            
        }
        
    }
    
}
