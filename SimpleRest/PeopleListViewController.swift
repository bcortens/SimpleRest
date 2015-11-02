//
//  ViewController.swift
//  SimpleRest
//
//  Created by Benjamin Cortens on 2015-11-01.
//  Copyright © 2015 Benjamin Cortens. All rights reserved.
//

import UIKit

class PeopleListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
	//	MARK: Properties
	
	var usersList: [RandomUser] = []
	//	Storyboard
	@IBOutlet weak var userTableView: UITableView!
	
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		self.userTableView.delegate = self
		self.userTableView.dataSource = self
		
		//	The User manager is the connection manager which connects to the remote server and is also responsible for handling the results
		let newUserManager: RandomUserManager = RandomUserManager()
		//	Set the parent view controller of the user manager
		newUserManager.parentViewController = self
		//	Get some random users (15 of them to be specific)
		newUserManager.getMultipleRandomUsers(15)
		
	}
	
	
	//	This is called by the RandomUserManager after it finishes parsing the data
	//	Used to update the list and show the new data
	func updateUsersData(userData: [RandomUser])
	{
			self.usersList = userData
			self.userTableView.reloadData()
	}

	override func didReceiveMemoryWarning()
	{
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	
	// MARK: - Table view data source
	
	//	Configure the cells
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
		let cellIdentifier = "PersonCell"
		let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! RandomUserTableViewCell
		
		//	Get the user from the usersList
		let user = self.usersList[indexPath.row]
		
		//	Generate the name for display
		var nameField = ""
		if(user.firstName != nil)
		{
			nameField = nameField + user.firstName!
		}
		if(user.lastName != nil)
		{
			if nameField != ""
			{
				nameField = nameField + " "
			}
			nameField = nameField + user.lastName!
		}
		cell.userNameLabel.text = nameField
		
		//	Load the photo for the user
		if(user.smallPictureURL != nil)
		{
			let imgURL = NSURL(string: user.smallPictureURL!)
			let imgData = NSData(contentsOfURL: imgURL!)
			let imageView = UIImage(data: imgData!)
			cell.thumbnailPhoto.image = imageView
		}
		
		
		return cell
	}
	
	//	Number of Rows in Section
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		//	DEBUGGING
		//	Print out the number of search results
		//		print("Count of serach results \(self.searchResults.count")
		return self.usersList.count
	}
	
	
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		// Get the new view controller using segue.destinationViewController.
		// Pass the selected object to the new view controller.
		
		if segue.identifier == "ShowDetail"
		{
			//	Get the detail view controller
			let userDetailViewController = segue.destinationViewController as! RandomUserViewController
			
			// Get the cell that generated this segue.
			//	Get the appropriate RandomUser item set it in the RandomUserViewController
			if let selectedUserCell = sender as? RandomUserTableViewCell
			{
				if(self.usersList.isEmpty == false)
				{
					let indexPath = self.userTableView.indexPathForCell(selectedUserCell)!
					let selectedUser = self.usersList[indexPath.row]
					userDetailViewController.user = selectedUser
				}
			}
		}
	}

}

