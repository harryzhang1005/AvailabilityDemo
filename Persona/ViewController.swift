//
//  ViewController.swift
//  Persona
//
//  Created by Hongfei Zhang on 10/6/17.
//  Copyright © 2017 Happy Guy. All rights reserved.
//

import UIKit
import Contacts
import AddressBook

class ViewController: UIViewController {
	
	@IBOutlet weak var profileImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		getNewData()
	}
	
	@IBAction func getNewData(){
		
		// availability conditions evaluated at compile time to ensure the code that follows can run on this iOS version
		if #available(iOS 9.0, *) {
			print("iOS 9.0 and greater")
			
			let (contact, imageData) = PersonPopulator.generateContactInfo()
			
			profileImageView.image = UIImage(data: imageData)
			titleLabel.text = contact.jobTitle
			nameLabel.text = "\(contact.givenName) \(contact.familyName)"
		}
		else { // fallback code to run on older versions
			print("iOS 8.4")
			// The Contacts framework instroduced in iOS 9 replaced the older Address Book framework
			let (record, imageData) = PersonPopulator.generateRecordInfo()
			
			let firstName = ABRecordCopyValue(record, kABPersonFirstNameProperty).takeRetainedValue() as! String
			let lastName = ABRecordCopyValue(record, kABPersonLastNameProperty).takeRetainedValue() as! String
			
			profileImageView.image = UIImage(data: imageData)
			titleLabel.text = ABRecordCopyValue(record, kABPersonJobTitleProperty).takeRetainedValue() as? String
			nameLabel.text = "\(firstName) \(lastName)"
		}
	}
	
}
