//
//  ViewController.swift
//  Persona-macOS
//
//  Created by Hongfei Zhang on 10/6/17.
//  Copyright © 2017 Happy Guy. All rights reserved.
//

import Cocoa
import Contacts
import AddressBook

class ViewController: NSViewController {
	
	@IBOutlet weak var profileImageView: NSImageView!
	@IBOutlet weak var titleField: NSTextField!
	@IBOutlet weak var nameField: NSTextField!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		getNewData(nil)
	}
	
	@IBAction func getNewData(_ sender: AnyObject?){
		
		let firstName: String, lastName: String, title: String, profileImage: NSImage
		
		if #available(OSX 10.11, *) {
			let (contact, imageData) = PersonPopulator.generateContactInfo()
			firstName = contact.givenName
			lastName = contact.familyName
			title = contact.jobTitle
			profileImage = NSImage(data: imageData)!
		}
		else {
			let (record, imageData) = PersonPopulator.generateRecordInfo()
			firstName = record.value(forProperty: kABFirstNameProperty) as! String
			lastName = record.value(forProperty: kABLastNameProperty) as! String
			title = record.value(forProperty: kABTitleProperty) as! String
			profileImage = NSImage(data: imageData)!
		}
		
		profileImageView.image = profileImage
		titleField.stringValue = title
		nameField.stringValue = "\(firstName) \(lastName)"
	}
	
}
