import util.*

class Person {

	String name
	Date dob
	Phone phoneNumber
	
	def getAgeInSeconds() {
		(new Date().getTime() - dob.getTime()) / 1000
	}
	
	def getAgeInDays() {
		ageInSeconds / 86400
	}
	
	def getAgeInYears() {
		ageInDays / 365.249
	}
	
	String toString() {
		"$name is $ageInYears years ($ageInDays days) old"
	}
	
}