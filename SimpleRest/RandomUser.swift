//
//  RandomUser.swift
//  SimpleRest
//
//  Created by Benjamin Cortens on 2015-11-01.
//  Copyright © 2015 Benjamin Cortens. All rights reserved.
//

import UIKit

//
//	This class stores the random user objects
//	They must first be parsed and validated by the API but once that is done they are placed into these simple objects
//
class RandomUser: NSObject
{
	//	MARK: Types
	struct PropertyKey
	{
		static let nameKey = "name"
		static let nameFirstKey = "first"
		static let nameLastKey = "last"
		static let nameTitleKey = "title"
		
		static let pictureKey = "picture"
		static let pictureSmallKey = "thumbnail"
		static let pictureLargeKey = "large"
		
		static let locationKey = "location"
		static let locationStreetKey = "street"
		static let locationCityKey = "city"
		static let locationStateKey = "state"
		static let locationZipKey = "zip"
		static let countryKey = "nationality"
		
		static let emailKey = "email"
		static let phoneKey = "phone"
		static let cellKey = "cell"
	}
	
	
	//	MARK: Properties
	var firstName: String?
	var lastName: String?
	var title: String?
	
	var smallPictureURL: String?
	var largePictureURL: String?
	
	var locationStreet: String?
	var locationCity: String?
	var locationState: String?
	var locationZIP: String?
	
	var countryCode :String?
	
	var email: String?
	
	var phone: String?
	var cell: String?
	
}
