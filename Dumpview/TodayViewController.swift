//
//  TodayViewController.swift
//  Dumpview
//
//  Created by Joep4U on 21-12-15.
//  Copyright © 2015 Joep de Jong. All rights reserved.
//s

import UIKit
import NotificationCenter

var videos = [Video]()

class TodayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NCWidgetProviding {
        
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TodayTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "TodayCell")
        tableView.rowHeight = 70
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        
        parseVideoXml(DumpertApi.getXML(DumpertApi.getRecentVideos(10))!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //println("numberOfRowsInSection")
        return videos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TodayTableViewCell = tableView.dequeueReusableCellWithIdentifier("TodayCell") as! TodayTableViewCell!
        //cell.articles = self.articles?[indexPath.row]
        //println("cellForRowAtIndexPath")
        let video = videos[indexPath.row] as Video
        //cell.textLabel?.text = video.title
        //cell.imageView?.image = video.thumb
        cell.thumb?.image = video.thumb
        cell.title?.text = video.title
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let id = videos[indexPath.row].id
        
        extensionContext?.openURL(NSURL(string:"dumpview://video?id=\(id)")!, completionHandler: nil)
        
        //VideoTableViewController().performSegueWithIdentifier("openVideo", sender: self)
        
    }
    
    func parseVideoXml(data: NSData) {
        
        let xml = SWXMLHash.parse(data)
        
        for video in xml["videos"]["video"] {
            if(!video["nsfw"]){
                Image.downloadImage(NSURL(string: video["thumb"].element!.text!)!, completion: { (image) -> Void in
                    
                    let id = video["id"].element!.text!
                    let thumb = image
                    let title = video["title"].element!.text!
                    let brief = video["brief"].element!.text!
                    let date = Functions.convertDateFormater(video["date"].element!.text!)
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
    
}
