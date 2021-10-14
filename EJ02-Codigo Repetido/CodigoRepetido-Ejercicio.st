!classDefinition: #CantSuspend category: 'CodigoRepetido-Ejercicio'!
Error subclass: #CantSuspend
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!


!classDefinition: #NotFound category: 'CodigoRepetido-Ejercicio'!
Error subclass: #NotFound
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!


!classDefinition: #CustomerBookTest category: 'CodigoRepetido-Ejercicio'!
TestCase subclass: #CustomerBookTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!

!CustomerBookTest methodsFor: 'tests' stamp: 'FA 10/13/2021 20:10:09'!
removeInvalidCustomerCheck
	! !

!CustomerBookTest methodsFor: 'tests' stamp: 'FA 10/14/2021 11:01:44'!
test01AddingCustomerShouldNotTakeMoreThan50Milliseconds

	|totalTime|
	
	totalTime := self getTimeWhenAddingWithCustomer: 'John Lennon'.
	
	self assert: (totalTime) < (50 * millisecond)
	
! !

!CustomerBookTest methodsFor: 'tests' stamp: 'FA 10/14/2021 11:02:02'!
test02RemovingCustomerShouldNotTakeMoreThan100Milliseconds	
	| totalTime|
	
	totalTime := self getTimeWhenRemovingWithCustomer: 'John Lennon'.
	
	self assert: (totalTime) < (100 * millisecond)
	
! !

!CustomerBookTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/9/2012 18:12'!
test03CanNotAddACustomerWithEmptyName 

	| customerBook |
			
	customerBook := CustomerBook new.

	[ customerBook addCustomerNamed: ''.
	self fail ]
		on: Error 
		do: [ :anError | 
			self assert: anError messageText = CustomerBook customerCanNotBeEmptyErrorMessage.
			self assert: customerBook isEmpty ]! !

!CustomerBookTest methodsFor: 'tests' stamp: 'FA 10/13/2021 20:13:57'!
test04CanNotRemoveAnInvalidCustomer
	
	| johnLennon |

	johnLennon := 'John Lennon'.
	self removingInvalidCustomerCheck: johnLennon.
! !

!CustomerBookTest methodsFor: 'tests' stamp: 'FA 10/13/2021 20:05:12'!
test05SuspendingACustomerShouldNotRemoveItFromCustomerBook

	| customerBook |
	
	customerBook := self checkSuspendingAClientNotRemoveIt: 'Paul McCartney'.
	
	self assertQuantity: #(0 1 1) in: customerBook. 
	self assert: (customerBook includesCustomerNamed: 'Paul McCartney').
	

	
! !

!CustomerBookTest methodsFor: 'tests' stamp: 'FA 10/13/2021 20:05:52'!
test06RemovingASuspendedCustomerShouldRemoveItFromCustomerBook

	| customerBook|
	
	customerBook := self checkRemovingASuspendedClient: 'Paul McCartney'.
	
	self assertQuantity: #(0 0 0) in: customerBook. 
	self deny: (customerBook includesCustomerNamed: 'Paul McCartney').


	
! !

!CustomerBookTest methodsFor: 'tests' stamp: 'FA 10/14/2021 11:00:35'!
test07CanNotSuspendAnInvalidCustomer
	
	| ringoStarr |
			
	ringoStarr  := 'Ringo Starr'.
	
	self suspendingCustomerCheck: ringoStarr.
! !

!CustomerBookTest methodsFor: 'tests' stamp: 'FA 10/14/2021 11:00:35'!
test08CanNotSuspendAnAlreadySuspendedCustomer
	
	| johnLennon |
			
	johnLennon := 'John Lennon'.
	
	self suspendingCustomerCheck: johnLennon.
	! !


!CustomerBookTest methodsFor: 'tests-aux' stamp: 'FA 10/13/2021 20:04:19'!
assertQuantity: numbers in: customerBook
	self assert: (numbers at: 1) equals: customerBook numberOfActiveCustomers.
	self assert: (numbers at: 2) equals: customerBook numberOfSuspendedCustomers.
	self assert: (numbers at: 3) equals: customerBook numberOfCustomers.! !

!CustomerBookTest methodsFor: 'tests-aux' stamp: 'FA 10/13/2021 16:37:39'!
checkRemovingASuspendedClient: customerName
	^self checkSuspendingAndRemovingClientsUsing: [:v | v addCustomerNamed: customerName.
		v suspendCustomerNamed: customerName ]  and: [:v | v  removeCustomerNamed: customerName ].! !

!CustomerBookTest methodsFor: 'tests-aux' stamp: 'FA 10/13/2021 16:37:48'!
checkSuspendingAClientNotRemoveIt: customerName
	^self checkSuspendingAndRemovingClientsUsing: [:v | v addCustomerNamed: customerName.
		v suspendCustomerNamed: customerName ]  and: [:v].! !

!CustomerBookTest methodsFor: 'tests-aux' stamp: 'FA 10/13/2021 16:33:46'!
checkSuspendingAndRemovingClientsUsing: aBlock and: optionalBlock
	|customerBook|
	
	customerBook := CustomerBook  new.
	aBlock value: customerBook.
	optionalBlock value: customerBook.
	
	^customerBook.! !

!CustomerBookTest methodsFor: 'tests-aux' stamp: 'FA 10/13/2021 19:17:59'!
customerBookCreator: customerName
	|customerBook|
	
	customerBook := CustomerBook  new.
	customerBook addCustomerNamed: customerName.
	customerBook suspendCustomerNamed: customerName.
	^customerBook ! !

!CustomerBookTest methodsFor: 'tests-aux' stamp: 'FA 10/14/2021 11:02:13'!
getTimeUsing: aBlock and: optionalBlock
	|customerBook millisecondsBeforeRunning millisecondsAfterRunning |
	
	customerBook := CustomerBook  new.
	optionalBlock value: customerBook.
	
	millisecondsBeforeRunning := Time millisecondClockValue * millisecond.
	aBlock value: customerBook.
	millisecondsAfterRunning := Time millisecondClockValue * millisecond.
	
	^millisecondsAfterRunning - millisecondsBeforeRunning.! !

!CustomerBookTest methodsFor: 'tests-aux' stamp: 'FA 10/14/2021 11:02:14'!
getTimeWhenAddingWithCustomer: customerName
	^self getTimeUsing: [:v | v addCustomerNamed: customerName] and: [:nilValue].! !

!CustomerBookTest methodsFor: 'tests-aux' stamp: 'FA 10/14/2021 11:02:14'!
getTimeWhenRemovingWithCustomer: customerName
	^self getTimeUsing: [:v | v removeCustomerNamed: customerName] and:
		[:v | v addCustomerNamed: customerName]! !

!CustomerBookTest methodsFor: 'tests-aux' stamp: 'FA 10/13/2021 20:13:21'!
removingInvalidCustomerCheck: customerName
	|customerBook|
	
	customerBook := self customerBookCreator: customerName.
	
	[ customerBook removeCustomerNamed: 'Paul McCartney'.
	self fail ]
		on: NotFound 
		do: [ :anError | 
			self assert: customerBook numberOfCustomers = 1.
			self assert: (customerBook includesCustomerNamed: customerName)]! !

!CustomerBookTest methodsFor: 'tests-aux' stamp: 'FA 10/14/2021 11:00:35'!
suspendingCustomerCheck: customerName
	|customerBook johnLennon|
	
	johnLennon := 'John Lennon'.
	
	customerBook := self customerBookCreator: johnLennon .
	
	[ customerBook suspendCustomerNamed: customerName.
	self fail ]
		on: CantSuspend 
		do: [ :anError | 
			self assert: customerBook numberOfCustomers = 1.
			self assert: (customerBook includesCustomerNamed: johnLennon ) ]
	
	
	! !


!classDefinition: #CustomerBook category: 'CodigoRepetido-Ejercicio'!
Object subclass: #CustomerBook
	instanceVariableNames: 'suspended active'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!

!CustomerBook methodsFor: 'initialization' stamp: 'LL 10/30/2020 12:22:04'!
initialize

	active := OrderedCollection new.
	suspended:= OrderedCollection new.! !


!CustomerBook methodsFor: 'customer management' stamp: 'FA 10/13/2021 16:25:22'!
addCustomerNamed: aName

	aName isEmpty ifTrue: [ self signalCustomerNameCannotBeEmpty ].
	(self includesCustomerNamed: aName) ifTrue: [ self signalCustomerAlreadyExists ].
	
	active add: aName ! !

!CustomerBook methodsFor: 'customer management' stamp: 'FA 10/13/2021 19:50:56'!
lookingFor: aName in: variableInstances
	1 to: variableInstances size do: 
	[ :index |
		aName = (variableInstances at: index)
			ifTrue: [
				variableInstances removeAt: index.
				^ aName 
			] 
	].
	^''! !

!CustomerBook methodsFor: 'customer management' stamp: 'FA 10/13/2021 19:50:20'!
removeCustomerNamed: aName 
 	|actual|
	
	actual := self lookingFor: aName in: active.
	(actual = aName) ifTrue: [^aName].
	
	actual := self lookingFor: aName in: suspended.
	(actual = aName) ifTrue: [^aName].
	
	^ NotFound signal.
! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 4/3/2019 10:14:26'!
suspendCustomerNamed: aName 
	
	(active includes: aName) ifFalse: [^CantSuspend signal].
	
	active remove: aName.
	
	suspended add: aName
! !


!CustomerBook methodsFor: 'accessing' stamp: 'NR 4/3/2019 10:14:26'!
numberOfActiveCustomers
	
	^active size! !

!CustomerBook methodsFor: 'accessing' stamp: 'NR 4/3/2019 10:14:26'!
numberOfCustomers
	
	^active size + suspended size! !

!CustomerBook methodsFor: 'accessing' stamp: 'NR 9/19/2018 17:36:09'!
numberOfSuspendedCustomers
	
	^suspended size! !


!CustomerBook methodsFor: 'testing' stamp: 'NR 4/3/2019 10:14:26'!
includesCustomerNamed: aName

	^(active includes: aName) or: [ suspended includes: aName ]! !

!CustomerBook methodsFor: 'testing' stamp: 'NR 4/3/2019 10:14:26'!
isEmpty
	
	^active isEmpty and: [ suspended isEmpty ]! !


!CustomerBook methodsFor: 'signal errors' stamp: 'HernanWilkinson 7/6/2011 17:52'!
signalCustomerAlreadyExists 

	self error: self class customerAlreadyExistsErrorMessage! !

!CustomerBook methodsFor: 'signal errors' stamp: 'HernanWilkinson 7/6/2011 17:51'!
signalCustomerNameCannotBeEmpty 

	self error: self class customerCanNotBeEmptyErrorMessage ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerBook class' category: 'CodigoRepetido-Ejercicio'!
CustomerBook class
	instanceVariableNames: ''!

!CustomerBook class methodsFor: 'error messages' stamp: 'NR 4/30/2020 09:05:18'!
customerAlreadyExistsErrorMessage

	^'Customer Already Exists'! !

!CustomerBook class methodsFor: 'error messages' stamp: 'NR 4/30/2020 09:05:25'!
customerCanNotBeEmptyErrorMessage

	^'Customer Name Cannot Be Empty'! !
