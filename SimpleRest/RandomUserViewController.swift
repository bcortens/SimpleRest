//
//  RandomUserViewController.swift
//  SimpleRest
//
//  Created by Benjamin Cortens on 2015-11-01.
//  Copyright © 2015 Benjamin Cortens. All rights reserved.
//

import UIKit

class RandomUserViewController: UIViewController
{
	
	@IBOutlet weak var largePhoto: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var firstLastLabel: UILabel!
	@IBOutlet weak var emailLabel: UILabel!
	@IBOutlet weak var phoneLabel: UILabel!
	@IBOutlet weak var cellLabel: UILabel!
	@IBOutlet weak var streetLabel: UILabel!
	@IBOutlet weak var cityLabel: UILabel!
	@IBOutlet weak var stateCountryLabel: UILabel!
	
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var contentView: UIView!
	
	//	Set by the PeopleListViewController
	var user: RandomUser?
	
    override func viewDidLoad()
	{
        super.viewDidLoad()

        if let user = self.user
		{
			var title = ""
			if user.title != nil
			{
				title = user.title!
			}
			self.titleLabel.text = title
			
			var name = ""
			if user.firstName != nil
			{
				name = name + user.firstName!
			}
			if user.lastName != nil
			{
				if name != ""
				{
					name = name + " "
				}
				name = name + user.lastName!
			}
			self.navigationItem.title = name
			self.firstLastLabel.text = name
			
			
			if(user.largePictureURL != nil)
			{
				let imgURL = NSURL(string: user.largePictureURL!)
				let imgData = NSData(contentsOfURL: imgURL!)
				let imageView = UIImage(data: imgData!)
				self.largePhoto.image = imageView
			}
			
			var email = ""
			if user.email != nil
			{
				email = email + user.email!
			}
			self.emailLabel.text = email
			
			var phone = ""
			if user.phone != nil
			{
				phone = phone + user.phone!
			}
			self.phoneLabel.text = phone
			
			var cell = ""
			if user.cell != nil
			{
				cell = cell + user.cell!
			}
			self.cellLabel.text = cell
			
			var street = ""
			if user.locationStreet != nil
			{
				street = street + user.locationStreet!
			}
			self.streetLabel.text = street
			
			var city = ""
			if user.locationCity != nil
			{
				city = city + user.locationCity!
			}
			self.cityLabel.text = city
			
			var stateCountry = ""
			if user.locationState != nil
			{
				stateCountry = stateCountry + user.locationState!
			}
			if user.countryCode != nil
			{
				if stateCountry != ""
				{
					stateCountry = stateCountry + " "
				}
				stateCountry = stateCountry + user.countryCode!
			}
			self.stateCountryLabel.text = stateCountry
			
		}
		
    }


    override func didReceiveMemoryWarning()
	{
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
