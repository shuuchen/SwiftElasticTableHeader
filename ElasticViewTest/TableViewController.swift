//
//  TableViewController.swift
//  ElasticViewTest
//
//  Created by Shuchen Du on 2016/03/16.
//  Copyright © 2016年 Shuchen Du. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    @IBOutlet weak var headerView: UIView!
    
    // threshold values
    private let minHeaderViewHeight: CGFloat = 100.0
    private let maxWaveHeight: CGFloat = 100.0
    private let maxAdditionalHeight: CGFloat = 170

    // shape layer
    private let shapeLayer = CAShapeLayer()
    
    // circle layer
    private let circleLayer = CAShapeLayer()
    
    // control point views
    private let l3ControlPointView = UIView()
    private let l2ControlPointView = UIView()
    private let l1ControlPointView = UIView()
    private let cControlPointView = UIView()
    private let r1ControlPointView = UIView()
    private let r2ControlPointView = UIView()
    private let r3ControlPointView = UIView()
    
    // display link for key frame animation
    private var displayLink: CADisplayLink!
    
    // whether animation is on
    private var animating = false {
        
        didSet {
            
            tableView.userInteractionEnabled = !animating
            displayLink.paused = !animating
        }
    }
    
    func initControlPointViews() {
        
        // frame
        l3ControlPointView.frame = CGRectMake(0.0, 0.0, 3.0, 3.0)
        l2ControlPointView.frame = CGRectMake(0.0, 0.0, 3.0, 3.0)
        l1ControlPointView.frame = CGRectMake(0.0, 0.0, 3.0, 3.0)
        cControlPointView.frame = CGRectMake(0.0, 0.0, 3.0, 3.0)
        r1ControlPointView.frame = CGRectMake(0.0, 0.0, 3.0, 3.0)
        r2ControlPointView.frame = CGRectMake(0.0, 0.0, 3.0, 3.0)
        r3ControlPointView.frame = CGRectMake(0.0, 0.0, 3.0, 3.0)
        
        // color
        /*
        l3ControlPointView.backgroundColor = UIColor.redColor()
        l2ControlPointView.backgroundColor = UIColor.redColor()
        l1ControlPointView.backgroundColor = UIColor.redColor()
        cControlPointView.backgroundColor = UIColor.redColor()
        r1ControlPointView.backgroundColor = UIColor.redColor()
        r2ControlPointView.backgroundColor = UIColor.redColor()
        r3ControlPointView.backgroundColor = UIColor.redColor()
*/
        
        // add to headerView
        headerView.addSubview(l3ControlPointView)
        headerView.addSubview(l2ControlPointView)
        headerView.addSubview(l1ControlPointView)
        headerView.addSubview(cControlPointView)
        headerView.addSubview(r1ControlPointView)
        headerView.addSubview(r2ControlPointView)
        headerView.addSubview(r3ControlPointView)
    }
    
    private func currentPath() -> CGPath {
        
        let bezierPath = UIBezierPath()
        
        bezierPath.moveToPoint(CGPoint(x: 0.0, y: 0.0))
        bezierPath.addLineToPoint(l3ControlPointView.getViewCenter(animating))
        bezierPath.addCurveToPoint(l1ControlPointView.getViewCenter(animating), controlPoint1: l3ControlPointView.getViewCenter(animating), controlPoint2: l2ControlPointView.getViewCenter(animating))
        bezierPath.addCurveToPoint(r1ControlPointView.getViewCenter(animating), controlPoint1: cControlPointView.getViewCenter(animating), controlPoint2: r1ControlPointView.getViewCenter(animating))
        bezierPath.addCurveToPoint(r3ControlPointView.getViewCenter(animating), controlPoint1: r1ControlPointView.getViewCenter(animating), controlPoint2: r2ControlPointView.getViewCenter(animating))
        bezierPath.addLineToPoint(CGPoint(x: tableView.bounds.width, y: 0.0))
        
        bezierPath.closePath()
        
        return bezierPath.CGPath
    }
    
    // also used for CADisplayLink, cannot be private
    func updateShapeLayer() {
        
        shapeLayer.path = currentPath()
    }
    
    private func layoutControlPoints(baseHeight: CGFloat, waveHeight: CGFloat, locationX: CGFloat) {
        
        let width = tableView.bounds.width
        
        let minLeftX = min((locationX - width / 2.0) * 0.28, 0.0)
        let maxRightX = max(width + (locationX - width / 2.0) * 0.28, width)
        
        let leftPartWidth = locationX - minLeftX
        let rightPartWidth = maxRightX - locationX
        
        l3ControlPointView.center = CGPoint(x: minLeftX, y: baseHeight)
        l2ControlPointView.center = CGPoint(x: minLeftX + leftPartWidth * 0.44, y: baseHeight)
        l1ControlPointView.center = CGPoint(x: minLeftX + leftPartWidth * 0.71, y: baseHeight + waveHeight * 0.64)
        cControlPointView.center = CGPoint(x: locationX , y: baseHeight + waveHeight * 1.36)
        r1ControlPointView.center = CGPoint(x: maxRightX - rightPartWidth * 0.71, y: baseHeight + waveHeight * 0.64)
        r2ControlPointView.center = CGPoint(x: maxRightX - (rightPartWidth * 0.44), y: baseHeight)
        r3ControlPointView.center = CGPoint(x: maxRightX, y: baseHeight)
    }
    
    private func addCircle() {
        
        let slx = shapeLayer.frame.origin.x
        let sly = shapeLayer.frame.origin.y
        let slw = shapeLayer.frame.width
        let slh = shapeLayer.frame.height
        let clw: CGFloat = 30
        let clh: CGFloat = 30
        let circleFrame = CGRectMake(slx + (slw-clw)/2, sly + (slh-clh)/2, clw, clh)
        let circleRect = CGRectMake(0, 0, clw, clh)
        
        circleLayer.frame = circleFrame
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.strokeColor = UIColor.redColor().CGColor
        circleLayer.lineWidth = 5
        circleLayer.path = UIBezierPath(ovalInRect: circleRect).CGPath
        circleLayer.strokeEnd = 0
        
        shapeLayer.addSublayer(circleLayer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // header view
        headerView =  tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        headerView.frame = CGRectMake(0.0, -minHeaderViewHeight, tableView.bounds.width, minHeaderViewHeight)
        
        // inset and offset
        tableView.contentInset = UIEdgeInsets(top: minHeaderViewHeight, left: 0.0, bottom: 0.0, right: 0.0)
        tableView.contentOffset.y = -minHeaderViewHeight
        
        // shape layer init
        shapeLayer.frame = CGRectMake(0.0, 0.0, tableView.bounds.width, minHeaderViewHeight)
        shapeLayer.fillColor = UIColor.purpleColor().CGColor
        headerView.layer.addSublayer(shapeLayer)
        
        // add circle to shape layer
        addCircle()
        
        // pan gesture recognizer
        tableView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "panGestureDidMove:"))
        
        // disable implicit animation
        shapeLayer.actions = ["position" : NSNull(), "bounds" : NSNull(), "path" : NSNull()]
        
        // control point views init
        initControlPointViews()
        
        // position init of control points and path
        layoutControlPoints(minHeaderViewHeight, waveHeight: 0.0, locationX: 0.0)
        updateShapeLayer()
        
        // display link init
        displayLink = CADisplayLink(target: self, selector: Selector("updateShapeLayer"))
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        displayLink.paused = true
    }
    
    private func updateHeaderView() {
        
        let headerRect = CGRectMake(0.0, tableView.contentOffset.y, tableView.bounds.width, -tableView.contentOffset.y)
        
        headerView.frame = headerRect
    }
    
    func panGestureDidMove(gesture: UIPanGestureRecognizer) {
        
        if gesture.state == .Ended || gesture.state == .Failed || gesture.state == .Cancelled {
            
            animating = true
            self.circleLayer.hidden = false
            
            // spring bounce
            UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: { [unowned self] in
                
                self.l3ControlPointView.center.y = self.minHeaderViewHeight
                self.l2ControlPointView.center.y = self.minHeaderViewHeight
                self.l1ControlPointView.center.y = self.minHeaderViewHeight
                self.cControlPointView.center.y = self.minHeaderViewHeight
                self.r1ControlPointView.center.y = self.minHeaderViewHeight
                self.r2ControlPointView.center.y = self.minHeaderViewHeight
                self.r3ControlPointView.center.y = self.minHeaderViewHeight
                
                self.tableView.contentOffset.y = -self.minHeaderViewHeight
                self.headerView.frame.origin.y = -self.minHeaderViewHeight
                self.headerView.frame.size.height = self.minHeaderViewHeight
                
                self.circleLayer.strokeEnd = 1
                
                }, completion: { [unowned self] _ in
                
                    self.animating = false
                    self.circleLayer.hidden = true
                    self.circleLayer.strokeEnd = 0
            })

        } else {
            
            // heights from location
            let location = gesture.locationInView(tableView)
            //let location = gesture.translationInView(tableView)
            
            let additionalHeight = min(max(0, location.y), maxAdditionalHeight)
            let waveHeight = min(additionalHeight * 0.6, maxWaveHeight)
            let baseHeight = minHeaderViewHeight + additionalHeight - waveHeight
            
            // update tableview position
            tableView.contentOffset.y = -(minHeaderViewHeight + additionalHeight)
            updateHeaderView()

            // update control points
            layoutControlPoints(baseHeight, waveHeight: waveHeight, locationX: location.x)
            
            // update path
            updateShapeLayer()
        }
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
        return 10
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell_id", forIndexPath: indexPath) as UITableViewCell

        cell.textLabel?.textAlignment = .Right
        cell.textLabel?.text = "\(indexPath.row)"

        return cell
    }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
