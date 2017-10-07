//
//  PersonPopulator.swift
//  Persona
//
//  Created by Hongfei Zhang on 10/6/17.
//  Copyright © 2017 Happy Guy. All rights reserved.
//

import Contacts		// start iOS 9, alongside with OS X version 10.11, means Contacts was also introduced on OS X in 10.11
import AddressBook	// for iOS 8.4

let names = ["Lincoln", "Einstein", "Darwin", "Galilei", "Khan", "Newton", "Caesar", "Gandhi", "Bonaparte", "Mandela", "McCartney"]

class PersonPopulator {
	
	// This attribute specifies that generateContatcInfo() is only available in iOS 9 and greater.
	// This specifies that generateContactInfo() is first available on OS X 10.11, to match the introduction of the Contacts framework.
	// Note: Because OS X was renamed macOS in macOS 10.12 Sierra, Swift recently added macOS as an alias for OSX. So both works.
	@available(iOS 9.0, OSX 10.11, *)
	class func generateContactInfo() -> (contact: CNContact, imageData: Data) {
		
		let randomName = names[Int(arc4random_uniform(UInt32(names.count)))]
		
		guard let path = Bundle.main.path(forResource: randomName, ofType: "vcf"),
			  let contacts = try? CNContactVCardSerialization.contacts(with: Data(contentsOf: URL(fileURLWithPath: path))),
			  let contact = contacts.first else {
				fatalError()
		}
		
		guard let imagePath = Bundle.main.path(forResource: randomName, ofType: "jpg"),
			  let imageData = try? Data(contentsOf: URL(fileURLWithPath: imagePath)) else {
				fatalError()
		}
		
		return (contact, imageData)
	}
	
	// for iOS 8.4 fallback
	// This attribute lets the compiler know that this code is deprecated in iOS 9, and provides a message to warn
	@available(iOS, deprecated: 9.0, message: "Use generateContactInfo()")
	@available(OSX, deprecated: 10.11, message: "Use generateContactInfo()")
	class func generateRecordInfo() -> (record: ABRecord, imageData: Data) {
		
		let randomName = names[Int(arc4random_uniform(UInt32(names.count)))]
		
		guard let path = Bundle.main.path(forResource: randomName, ofType: "vcf") else { fatalError() }
		guard let data = try? Data.init(contentsOf: URL(fileURLWithPath: path)) as CFData else { fatalError() }
		
		// use preprocessor command
		#if os(iOS)
			let person = ABPersonCreate().takeRetainedValue()
			let people = ABPersonCreatePeopleInSourceWithVCardRepresentation(person, data).takeRetainedValue()
			let record = NSArray(array: people)[0] as ABRecord
		#elseif os(OSX)
			let person = ABPersonCreateWithVCardRepresentation(data).takeRetainedValue() as AnyObject
			guard let record = person as? ABRecord else { fatalError() }
		#else
			fatalError()
		#endif
		
		guard let imagePath = Bundle.main.path(forResource: randomName, ofType: "jpg"),
			let imageData = try? Data(contentsOf: URL(fileURLWithPath: imagePath)) else {
				fatalError()
		}
		
		return (record, imageData)
	}

}
