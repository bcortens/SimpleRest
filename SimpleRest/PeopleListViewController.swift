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
		
		let newUserManager: RandomUserManager = RandomUserManager()
		newUserManager.parentViewController = self
		newUserManager.getMultipleRandomUsers(15)
		
		
//		print("Created random user")
//		newUserManager.getOneRandomUser()
		
		
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
		
		let user = self.usersList[indexPath.row]
		
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
		//print("Name \(nameField)")
		cell.userNameLabel.text = nameField
		
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
			let userDetailViewController = segue.destinationViewController as! RandomUserViewController
			
			// Get the cell that generated this segue.
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

