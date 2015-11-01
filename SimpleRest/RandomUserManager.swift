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
//
class RandomUserManager
{
	let randomUserBaseURL = "http://api.randomuser.me/"
	var dataResponse: NSData?
	var usersResponse: [RandomUser]?
	var parentViewController: PeopleListViewController?
///	do{
//	let jsonInformation =
//	}
	
	func getOneRandomUser()
	{
		print("Get One Random User")
		self.performHttpGet(self.randomUserBaseURL, number: nil)
	}
	
	func getMultipleRandomUsers(number: Int)
	{
		self.performHttpGet(self.randomUserBaseURL, number: String(number))
	}
	
	func performHttpGet(urlString: String, number: String?)
	{
		var request: NSMutableURLRequest!
		if(number?.isEmpty == false)
		{
			let newURLString = urlString + "?results=" + number!
			request = NSMutableURLRequest(URL: NSURL(string: newURLString)!)
		}
		else
		{
			request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
		}
		request.HTTPMethod = "GET"
		
		let urlSession = NSURLSession.sharedSession()
		
		print("Request is: \(request)")
		
		let urlGetTask = urlSession.dataTaskWithRequest(request, completionHandler: {(data,response,error) -> Void in
			//	Block within the function call to handle the data response
			if error != nil
			{
				print("Error \(error?.localizedDescription)")
			}
			else
			{
				print("Parse respones")
				self.parseResponseData(data)
				
				if self.parentViewController != nil
				{
					print("Reload data")
					// Make sure that we reload the data only on the main thread
					// If don't dispatch the reload command to the main thread then the UI can become out of sync and may lead to crashing
					dispatch_async(dispatch_get_main_queue(), {
						self.parentViewController?.updateUsersData(self.usersResponse!)
					})
					
				}
			}
			
		})//	End of call to urlSession.dataTaskWithRequest
		urlGetTask.resume()
	}
	
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
				print("Error serializing \(error)")
			}
		}
	}
}
