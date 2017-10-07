# Availability attribute Demo in Swift

## Demo code

```Swift
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
```

## More Info About @available

These availability attributes may be placed directly above any declaration in your code, other than a stored variable. 
This means that all of the following can be preceded by an attribute: 
Classes, Structs, Enums, Enum cases, Methods, Functions

To indicate the first version of an operating system that a declaration is available, use the following code:
```Swift
@available(iOS, introduced: 9.0)
```

The shorthand, and preferred syntax, for making the first version available is shown below:
```Swift
@available(iOS 9.0, *)
```

This shorthand syntax allows you to include multiple "introduced:" attributes in a single attribute:
```Swift
@available(iOS, introduced: 9.0)
@available(OSX, introduced: 10.11)
@available(iOS 9.0, OSX 10.11, *)		// same with the above two lines
```

Other attributes specify that a certain declaration no longer works:
```Swift
@available(watchOS, unavailable)		// means not available on any version of the specified platform
@available(watchOS, deprecated: 3.0)
@available(watchOS, obsoleted: 3.0)
```

You can also combine a renamed argument with an unavailable argument that helps Xcode provide autocomplete support when used incorrectly.
@available(iOS, unavailable, renamed: "NewName")

## The following is a list of the platforms you can specify availability for:

iOS, OSX, tvOS, watchOS
iOS/OSX/tvOS/watchOS/ApplicationExtension

The platforms that end with ~ApplicationExtension are extensions like custom keyboards, Notification Center widgets, and document providers.

Note: The asterisk in the shorthand syntax tells the compiler that the declaration is available on the minimum deployment target on any other platform.
For example, @available(iOS 9.0, *) states that the declaration is available on iOS 9.0 or greater, as well as on the deployment target of any other platform you support in the project.

On the other hand, @available(*, unavailable) states that the declaration is unavailable on every platform supported in your project.

Happy coding :+1:  :sparkles:
