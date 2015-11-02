//
//  RandomUserManager.swift
//  SimpleRest
//
//  Created by Benjamin Cortens on 2015-11-01.
//  Copyright © 2015 Benjamin Cortens. All rights reserved.
//

import UIKit


//
//	This class is responsible for connecting to, and parsing responses from, the RandomUser API
//	https://randomuser.me/
//	Uses NSURLSession and NSURLRequest directly rather than relying upon a higher level framework
//	Uses a block to handle the responses to the data requests
class RandomUserManager
{
	//	MARK: Constants
	let randomUserBaseURL = "http://api.randomuser.me/"

	
	//	MARK: Properties
	
	var dataResponse: NSData?
	var usersResponse: [RandomUser]?
	var parentViewController: PeopleListViewController?
	
	
	//	MARK: Getters for outside classes
	
	//	Uses performHttpGet to get a single random user from the RandomUserAPI
	func getOneRandomUser()
	{
		self.performHttpGet(self.randomUserBaseURL, number: nil)
	}
	
	func getMultipleRandomUsers(number: Int)
	{
		self.performHttpGet(self.randomUserBaseURL, number: String(number))
	}
	
	
	
	//	MARK: HTTP Calls
	
	//	Get random user (one or more)
	func performHttpGet(urlString: String, number: String?)
	{
		var request: NSMutableURLRequest!
		
		//	If requesting more than one user append the results optional parameter and the number of results to get
		//	Can get up to 1000 random users
		if(number?.isEmpty == false)
		{
			let newURLString = urlString + "?results=" + number!
			request = NSMutableURLRequest(URL: NSURL(string: newURLString)!)
		}
		else
		{
			request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
		}
		//	Set the HTTP Request method
		request.HTTPMethod = "GET"
		
		
		let urlSession = NSURLSession.sharedSession()
		
		//	The main get action
		//	Generate the appropriate data task request (doesn't perform the task yet)
		let urlGetTask = urlSession.dataTaskWithRequest(request, completionHandler: {(data,response,error) -> Void in
			//	Block within the function call to handle the data response
			if error != nil
			{
				print("Error \(error?.localizedDescription)")
			}
			else
			{
				//	DEBUG PRINT:
				//print("Parse respones")

				//	If didn't generate an error, then parse the data
				self.parseResponseData(data)
				
				if self.parentViewController != nil
				{
					// DEBUG PRINT:
					//	print("Reload data")
					
					
					// Make sure that we reload the data only on the main thread
					// If don't dispatch the reload command to the main thread then the UI can become out of sync and may lead to crashing
					// The NSURLSession runs automatically on the background thread, need to cal lthe response on the main thread (use Grand Central Dispatch dispatch_async) to do so.
					dispatch_async(dispatch_get_main_queue(), {
						self.parentViewController?.updateUsersData(self.usersResponse!)
					})
					
				}
			}
			
		})//	End of call to urlSession.dataTaskWithRequest
		
		//	Perform the actual get request
		//	NSURLSession automatically runs on the background thread
		urlGetTask.resume()
	}
	
	
	//	MARK: Parser
	
	//	Parse the data response
	//	Assumes that all values can be optional
	//	Uses the RandomUser API (documentation can be found at the link at the top of this class)
	func parseResponseData(data: NSData?)
	{
		if(data != nil)
		{
			do
			{
				let convertToJson = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
				
				if let resultsObjects = convertToJson["results"] as? NSArray
				{
					self.usersResponse = [RandomUser]()
					for result in resultsObjects
					{
						if let currentUser = result["user"] as? NSDictionary
						{
						//	print("user")
						//	print(currentUser)
							let newUser = RandomUser()
//							newUser.firstName = ""
							if let name = currentUser[RandomUser.PropertyKey.nameKey] as? NSDictionary
							{
								if let title = name[RandomUser.PropertyKey.nameTitleKey] as? NSString
								{
									newUser.title = title as String
								}
								if let firstName = name[RandomUser.PropertyKey.nameFirstKey] as? NSString
								{
									newUser.firstName = firstName as String
								}
								if let lastName = name[RandomUser.PropertyKey.nameLastKey] as? NSString
								{
									newUser.lastName = lastName as String
								}
							}
							if let location = currentUser[RandomUser.PropertyKey.locationKey] as? NSDictionary
							{
								if let city = location[RandomUser.PropertyKey.locationCityKey] as? NSString
								{
									newUser.locationCity = city as String
								}
								if let street = location[RandomUser.PropertyKey.locationStreetKey] as? NSString
								{
									newUser.locationStreet = street as String
								}
								if let state = location[RandomUser.PropertyKey.locationStateKey] as? NSString
								{
									newUser.locationState = state as String
								}
								if let zip = location[RandomUser.PropertyKey.locationZipKey] as? NSString
								{
									newUser.locationZIP = zip as String
								}
							}
							if let country = currentUser[RandomUser.PropertyKey.countryKey] as? NSString
							{
								newUser.countryCode = country as String
							}
							if let email = currentUser[RandomUser.PropertyKey.emailKey] as? NSString
							{
								newUser.email = email as String
							}
							if let phone = currentUser[RandomUser.PropertyKey.phoneKey] as? NSString
							{
								newUser.phone = phone as String
							}
							if let cell = currentUser[RandomUser.PropertyKey.cellKey] as? NSString
							{
								newUser.cell = cell as String
							}
							if let pictures = currentUser[RandomUser.PropertyKey.pictureKey] as? NSDictionary
							{
								if let smallPicture = pictures[RandomUser.PropertyKey.pictureSmallKey] as? NSString
								{
									newUser.smallPictureURL = smallPicture as String
								}
								if let largePicture = pictures[RandomUser.PropertyKey.pictureLargeKey] as? NSString
								{
									newUser.largePictureURL = largePicture as String
								}
							}
							
							self.usersResponse?.append(newUser)
						}
						
					}
				}
				
			}
			catch
			{
				//	An error converting the data object to JSON
				print("Error serializing \(error)")
			}
		}	//	End of check to make sure data is not nil
	}	//	End of parsing
}
