//
//  main.swift
//  mySwiftPrograms
//
//  Created by geniusport on 11/5/15.
//  Copyright © 2015 adeptPros. All rights reserved.
//

import Foundation

//TypeAlias or typedef
typealias sharad = Int


/****** VARIABLE DECLARATION ******/
/*
SYNTAX :
var variable_Name = variable_Value                      ->Inferred Declaration
var variable_Name:variable_Type                         ->Type Annotation
var variable_Name:variable_Type = variable_Value        ->Type Annotation with Initializing
var variable_Name:variable_Type? = variable_Value       ->Optional Declaration (Forced Unwrapped)
var variable_Name:variable_Type! = variable_Value       ->Optional Declaration (Automatic Unwrapped)
var (var_name1..var_name3) = (value_1..value_n)         ->Tuple Declaration (i.e., var_name1 = var_value)
*/


//Integer
var myInt1 = 10                             //Inferred Declaration
var myInt2:Int                              //Type Annotation
var myInt3:Int = 10                         //Type Annotation with Initializing
var myInt4:Int? = 10                       //Optional Declaration (Forced Unwrapped)
var myInt5:Int! = 10                        //Optional Declaration (Automatic Unwrapped)
var (a,b):(Int,Float) = (20,10.4)

//Floating Point
var myFloat1 = 10                           //Inferred Declaration
var myFloat2:Float                          //Type Annotation
var myFloat3:Float = 10.35                  //Type Annotation with Initializing
var myFloat4:Float? = 10                    //Optional Declaration (Forced Unwrapped)
var myFloat5:Float! = 10                    //Optional Declaration (Automatic Unwrapped)

//Double Precission
var myDouble1 = 10                           //Inferred Declaration
var myDouble2:Double                         //Type Annotation
var myDouble3:Double = 10.35                 //Type Annotation with Initializing
var myDouble4:Double? = 10                   //Optional Declaration (Forced Unwrapped)
var myDouble5:Double! = 10                   //Optional Declaration (Automatic Unwrapped)

//Chracter
var myChar1 = "A"                           //Inferred Declaration
var myChar2:Character                       //Type Annotation
var myChar3:Character = "B"                 //Type Annotation with Initializing
var myChar4:Character? = "C"                //Optional Declaration (Forced Unwrapped)
var myChar5:Character! = "C"                //Optional Declaration (Automatic Unwrapped)

//String
var myStr1 = "Hello"                        //Inferred Declaration
var myStr2:String                           //Type Annotation
var myStr3:String = "Hello, Sir!"           //Type Annotation with Initializing
var myStr4:String? = "Hello, Sharad"        //Optional Declaration (Forced Unwrapped)
var myStr5:String! = "Hello Adeptpros"      //Optional Declaration (Automatic Unwrapped)
var myStr6 = String()                       //Empty String
/* ARRAY DECLARATION  SYNTAX :
            
var Array_Name = [Value_1,Value_2,...Value_n]
var Array_Name:[]
var Array_Name:[array_type]
var Array_Name:[array_type] = [Value_1,Value_2,...Value_n]
var Array_Name:[array_type]? = [Value_1,Value_2,...Value_n]
var Array_Name:[array_type]! = [Value_1,Value_2,...Value_n]

*/

//Array
var myArr1 = [10,20,30]                     //Inferred Declaration
var myArr2:[Int]                            //Type Annotation
var myArr3:[String] = ["Sharad","Raj"]      //Type Annotation with Initializing
var myArr4:[String]? = ["Sharad"]           //Optional Declaration (Forced Unwrapped)
var myArr5:[Float]! = [10.2,20.3]           //Optional Declaration (Automatic Unwrapped)
var myArr6 = []                             //Empty Array
var myArr7 = [Int] (count: 4, repeatedValue: 10) //No of Array values are 4  and values are 10

/* DICTIONARY DECLARATION  SYNTAX :

var Dictionary_Name = [Key_1:Value_1,Key_1:Value_1,...Key_n:Value_n]
var Dictionary_Name:[]
var Dictionary_Name:[Key_Type:Value_Type]
var Dictionary_Name:[Key_Type:Value_Type] = [Key_1:Value_1,Key_1:Value_1,...Key_n:Value_n]
var Dictionary_Name:[Key_Type:Value_Type]? = [Key_1:Value_1,Key_1:Value_1,...Key_n:Value_n]
var Dictionary_Name:[Key_Type:Value_Type]! = [Key_1:Value_1,Key_1:Value_1,...Key_n:Value_n]

*/

//Dictionary
var myDictionary1 = [1:"Sharad"]                            //Inferred Declaration
var myDictionary2:[Int:String]                              //Type Annotation
var myDictionary3:[String:String] = ["Sharad":"Raj"]        //Type Annotation with Initializing
var myDictionary4:[String:Int]? = ["Sharad":25]             //Optional Declaration (Forced Unwrapped)
var myDictionary5:[String:Float]! = ["Shard":6.1,"Raj":6.3] //Optional Declaration (Automatic Unwrapped)
var myDictionary6 = [:]                                     //Empty Dictioanry

/***** END OF VARIABLE DICLARATION ******/

/*-------------------------------------------------------------------------------------------------------------*/

/****** PRINTING OUTPUT ******/

//Display Datatypes
print("The Integer Value:%d",myInt1)
print("The Integer Value:",myInt1)
print(myInt1)
print(myFloat1)
print(myDouble1)
print(myChar1)

//Display Collection Type Class Variable
print(myStr1)
print("Number of Apples \(myInt1) in basket");
print(myArr1)
print(myArr1[0])                    //Enumerating Value by index

print(myDictionary1)
print(myDictionary3["Shaard"])     //Enumerating Value by Key

for (keys,item) in myDictionary3 {
    
    print("Dictionary Key: \(keys) and Value: \(item)")             //String Interpolation
}

/****** END OF PRINTING OUTPUT ******/

/*-------------------------------------------------------------------------------------------------------------*/

/****** OPERATORS *******/

/*
Unary Operator -> (Ex: -5, +6, -3.234)
Arthematic Operator ->(Ex: +,-,*,/,%,++,--)
Relational Operator ->(Ex: ==,<=,>=,<,>,!=,===,!==)
Assignment Operator ->(Ex: =,+=,-=,/=,%=)
Bitwise Operator    ->(Ex: &,|,^)
Logical Operator    ->(Ex: &&,||,!)
Special Operator    ->Conditional Operator (Ex: a==b?a:b)
                    ->Nil Coalescing Operator(Ex: ??)
                    ->Range Operator (Ex: a...b) a:Staring index b:End Index
                    ->Half Range Operator (Ex: a..>b)     Note:Always a<b
*/

//Nil Coalescing Operator
let xString = "Sharad"
var x:String?

var xNewString = x ?? xString           //if x is nil then xNewString contains the xString Value
print(xNewString)                       //if x as some value then xNewString contains x value

//Range Operator 
for index in 0...5{                     //Specifying the range b/w 0-5
    print(index)
}
for index in 0..<5{
    print(index)
}
/****** END OF OPERATORS *******/

/*-------------------------------------------------------------------------------------------------------------*/

/***** CONTROL AND LOOPING STATEMENTS ******/
/*
1. Control Statements

        if,switch,gaurd              -> to execute different branches of code
        break(fallthrough),continue               -> to continue or break the code of execution

2. Looping Statements

        for,while,repeat(do while)
        for-in                      ->for-in used to iterate over the array,dictionary,set,range and other sequence

3. Labeled Statement
    A labeled statement is indicated by placing a label on the same line as the statement’s introducer keyword, 
    followed by a colon.Although the principle is the same for all loops and switch statements.

 Syntax

    /* IF */
       
        if conditons {
            //true Block
        }
        else if condition {
            //True Block
        }
        else{
            //False Block
        }

    /* SWITCH */

        1. Default
            switch someValue {
                case value 1            :respond to value 1
                case value 2,value 3    :respond to value 2 or 3
                default                 :otherwise, do something else
            }
        
        2. Interval Matching (Using Range Operator and Half Range Operator)
            switch someValue {
                case value 1                :respond to value 1
                case value_a..<value_b      :respond to rangeValue        ->Specifying the range in Case Constant
                default                     :otherwise, do something else
            }
        
        3. Tuple (Passing Case constant as Tuple)
            switch (someValue1, someValue2) {
                case (value1, value2)               :respond to value 1
                case (val_a...val_b, value2)        :respond to rangeValue or Value2        ->Specifying the range in Case Constant
                case (val_1, val_a...val_b)         :respond to value 1 or rangeValue
                default                             :otherwise, do something else
            }
        
        4. Value Binding
            A switch case can bind the value or values it matches to temporary constants or variables, 
            for use in the body of the case. This is known as value binding

            switch (someValue1, someValue2) {
                case (let var_name, 0)              :respon to Case or use var_name in the case body
                case (0, let var_name)              :respon to Case or use var_name in the case body
                case let (var_name1, var_name2)     :respon to Case or use var_name1 and var_name2 in the case body
            }
       
        5. Where Clause
            switch (someValue1, someValue2) {
                case let (var_name1, var_name2) where conditon  :respon to Case or use var_name in the case body
            }

    /* FOR */
        
        1. Simple For 
            
            for initialize; condition; increment/Decrement {
                    //code here
            }
        
        2. For-in
            
            for var_name in collectionType_Varbiale {
                    //code here
            }
        
        3. For-in with range Operator

            for var_name in val_a...val_b {
                    //code here
            }
        
        4. For-in with half range Operator

            for var_name in val_a..<val_b {             //Any assignment operator
                //code here
            }

        5. For-in with tuple values

            for (var_name1,var_name2) in val_a..<val_b {             //Any assignment operator
                //code here
            }

    /* WHILE */
        
        while condition{
            //code
        }

    /* REPEAT/DO-While */

        repeat{
            //code here
        }while condition

    /* Labeled Statement */

        label_Name: loop Statement

*/
//IF Statement
var someValue = 5
if someValue > 3{
    print(someValue)
}else{
    print("Some Value is Not Some Value")
}

//FOR Statement
for i in 1..<someValue{                 //specifying range of the value for increment
    print(i)
}

for var i = 0; i < 5; i++ {             //simple for loop
    print(i)
}

// SWITCH Statement
//1. Example 1
switch("A"){
    case "A"        :print("A")
    case "B"        :print("B")
    default         :print("Default")
}
/*---------------------------------------------------*/
//2. Example 2
let someCharacter: Character = "e"
switch someCharacter {
    case "a", "e", "i", "o", "u"        :print("\(someCharacter) is a vowel")
    case "b", "c", "d", "f", "g"        :print("\(someCharacter) is a consonant")
    default                             :print("\(someCharacter) is not a vowel or a consonant")
}
/*---------------------------------------------------*/
//3. Example 3 (Interval Matching)
let approximateCount = 62
let countedThings = "moons orbiting Saturn"
var naturalCount: String
switch approximateCount {
    case 0              :naturalCount = "no"
    case 1..<5          :naturalCount = "a few"
    case 5..<12         :naturalCount = "several"
    case 12..<100       :naturalCount = "dozens of"
    case 100..<1000     :naturalCount = "hundreds of"
    default             :naturalCount = "many"
}
print("There are \(naturalCount) \(countedThings).")
/*---------------------------------------------------*/
//4. Example (Using Tuple and Range Operator)
let somePoint = (1, 1)
switch somePoint {
    case (0, 0)             :print("(0, 0) is at the origin")
    case (-2...2, -2...2)   :print("(\(somePoint.0), \(somePoint.1)) is inside the box")        //Specifying Range in Case Constant
    default                 :print("(\(somePoint.0), \(somePoint.1)) is outside of the box")
}
/*---------------------------------------------------*/
//5. Example (Using value Binding)
let someVlaue = (1,2)
switch someVlaue{
case (let x, 2)         :print("X:\(x)")
case (0, let y)         :print("X:\(y)")
case (let x, let y)     :print("X:\(x) and Y:\(y)")
}
/*---------------------------------------------------*/
//6. Example (Using Where Clause)
let yetAnotherPoint = (1, -1)
switch yetAnotherPoint {
case let (x, y) where x == y        :print("(\(x), \(y)) is on the line x == y")
case let (x, y) where x == -y     :print("(\(x), \(y)) is on the line x == -y")
case let (x, y)                             :print("(\(x), \(y)) is just some arbitrary point")
}

//WHILE Statement
var i=0
while i<5{
    print(i)
    i++
}

//DO_WHILE/REPEAT Statement
var n=0
repeat{
    print(n)
    n = n + 1
}
while n < 5

//LABELED Statements
var ab=0
myLabelWhile:while ab<10{
    print(ab)
    if ab==6{
       break myLabelWhile
    }
    else{
        ab++
        continue myLabelWhile
    }
}

//GUARD Statement -> its Almost like if-else statement
var ac:Int = 4
guard let ad:Int = ac else{
    print("Else Block")
}

/***** END OF CONTROL AND LOOPING STATEMENTS ******/

/*-------------------------------------------------------------------------------------------------------------*/

/***** COLLECTION TYPE CLASSES (Array, Dictionary,Set)*****/

/* STRING */

//Declaring String type
var myString1="Hello Adeptpros";                      //mutable String
var myString2:String="Hello Geniusport"
var myString3:String?="Hello, Trainees"
var myString4:String!="Hello, Trainees"
var myString5:String=""


/* String Functionality */
//---------------------------------------------------//

//Checking String is Empty or not

if myString5.isEmpty {
    print("YES")
}

//String Concatenating (Appending)

var myNewString1 = myString1 + myString2
print(myNewString1)

var myNewString2 = "Sharad"
var character:Character = "A"

myNewString2.append(character)
print(myNewString2)

//Iterating Characters from String
for characters in myNewString2.characters{
    print(characters)
}
// characters.dropFirst() //Print index character
var myValueChar1 = myNewString2.characters.dropFirst(2)
for characters in myValueChar1{
    print(characters)
}
// characters.dropLast() //Prints till index character
var myValueChar2 = myNewString2.characters.dropLast(3)
for characters in myValueChar2{
    print(characters)
}

//Range of String

var startIndex = myNewString2.startIndex.advancedBy(2)
print(myNewString2[startIndex])

var endIndex = myNewString2.endIndex.advancedBy(-3)
print(myNewString2[endIndex])

print(myNewString2[Range(start: startIndex, end: endIndex)])

print(myNewString2.substringFromIndex(startIndex))
print(myNewString2.substringToIndex(endIndex))
print(myNewString2.substringWithRange(Range(start:myNewString2.startIndex, end: myNewString2.endIndex)))

//Length of String
let countCharacters = myNewString2.characters.count
print(countCharacters)

//Finding String in String

if myNewString2.containsString("Shar"){
    print("YES")
}

//Array to String
var stringArray = ["Sharad", "Nagendra"]
let arrayToString = String(stringArray)
print(arrayToString)


//Inserting and Removing Character in String

myNewString2.insert("D", atIndex: myNewString2.startIndex)
print(myNewString2)

myNewString2.insertContentsOf("Adeptpros".characters, at: myNewString2.endIndex)
print(myNewString2)

myNewString2.removeAtIndex(myNewString2.startIndex.advancedBy(4))
print(myNewString2)

var range = myNewString2.startIndex.advancedBy(6)..<myNewString2.endIndex
myNewString2.removeRange(range)     //Range parameter means pass Range Operator Variable
print(myNewString2)


// hasPrefic and hasSuffix

if myNewString2.hasPrefix("Ash"){
    print("YES")
}
else{
    print("No")
}
if myNewString2.hasSuffix("ard"){
    print("YES")
}
else{
    print("No")
}

/* NSSTRING AND NSMUTABLESTRING */

var nsString1 = "NSSTRING"              //immuatble NSString
var nsString2 = NSString.init(string: "Sharad")     //immuatable NSString
var nsString3 = NSString()              //immutable and Empty String
var nsString4 = NSMutableString.init()  //in Objective-c -> NSMutableString *str=[NSMutaableString alloc]init];

//Some of Methods

print(nsString1.stringByAppendingString(" Rao"))
nsString1.lowercaseString
print(nsString1)
nsString4 = "Sharad"
nsString4.replaceCharactersInRange(NSMakeRange(1, 3), withString: "ABC")
print(nsString4)


var newNSString = nsString3.stringByAppendingFormat("%d", 10)

print(newNSString)
/*******  END OF STRING ******/


/*-------------------------------------------------------------------------------------------------------------*/

/**** ARRAY *****/
//Swift’s Array type is bridged to Foundation’s NSArray class.

//Declaring Array
var myArray = []                                    //Empty Array Declaration
var myArray1=[10,20,30];                            // inferred  Declaration
var myArray2 = [Int] (count: 3, repeatedValue: 10)  //Defining with Default Values
var myArray3=[String]()                             //Initializer Declaration
myArray3=["Sharad","Pavan","Uday"];

//Count property
print(myArray3.count)

//Empty Property

if myArray3.isEmpty{
    print("Empty")
}
else{
    print(myArray3)
}

//Iterating Values from Array
for myNum in myArray1{
    print("Numbers :\(myNum)")
}
for item in 1..<myArray1.count{         //Using Half range Operator
   print(myArray1[item])
}
for (index, item) in myArray3.enumerate(){
    print("Index: \(index) Value: \(item)")
}
//Modifyting Array

//Creating new Array from other arrays
var myNewArray1 = myArray3[1] + myArray3[2]
print(myNewArray1)

var myNewAddedArray = myArray1 + myArray2
print(myNewAddedArray)

//Adding new Value in Array
myArray3.append("Rajesh")       //added at the end of array
print(myArray3)

var newValue=["Reshma"]
myArray3 += newValue            //OR myArray3 += ["Reshma"]
print(myArray3)

myArray3.insert("Malvika", atIndex: myArray3.count-1)   //insert New Value at Specific index
print(myArray3)

//Replacing Array Values using Range Operator

myArray3[3...5] = ["Rajeev", "Sandeep"]
print(myArray3)

//Remove value from array
myArray3.removeAtIndex(2)


/* NSARRAY and NSMUTABLEARRAY */

var myNSArray1 = NSArray.init(array: ["Sharad","Nagendra"])
print(myNSArray1)
var myMutableArray:NSMutableArray = ["AB","BC","CD"]
print(myMutableArray)


myNSArray1 = myNSArray1.arrayByAddingObject("Arjun")
print(myNSArray1)
var myArrayString = myNSArray1.componentsJoinedByString("-")
print(myArrayString)

print("Elments in Array",myMutableArray.count)
print("Element :\(myMutableArray.objectAtIndex(1))")

myMutableArray.addObject("DE")
myMutableArray.removeObject("BC", inRange: NSMakeRange(0, 3))


/***** END OF ARRAY *****/


/***** DICTIONARY *****/

//Decalring Dictionary
var myDict = [:]                         //Empty Dictionary Declaration
var myDict1 = ["1":1,"2":2]             //[Key : Value] where key->String and Value->Int
print(myDict1)
var myDict2 = [Int : String]()          //intializer Decaration
myDict2 = [1:"One", 2:"Two"]        //[Key : Value] where key->Int and Value->String
print(myDict2)

var myDict3:[Int : String] = [1:"Rajesh",2:"Sharad"]    //Optional Intializer

//Accessing Dictionary
print(myDict3)                                      //print the Dictionary Values

var myNewString = myDict3[1]
print(myNewString)

//Count property
print(myDict3.count)

//Empty Property

if myDict3.isEmpty{
    print("Empty")
}
else{
    print(myDict3)
}

//Iterating Dictionary
for (key, value) in myDict3{                                //As tuple values
    print("Value :\(value)  Key:\(key)")
}

//Convert into Array

var myArrayKeysFromDict = [Int](myDict2.keys)
print(myArrayKeysFromDict)

var myArrayValuesFromDict = [String](myDict2.values)
print(myArrayValuesFromDict)

for (keys) in myDict3{                  //Retriving Keys as Array from Dict
    print(keys)
}

for (values) in myDict3{                  //Retriving values as Array from Dict
    print(values)
}

//Modifying Dictionary 

//Updating Old Value in Dictionary

myDict3.updateValue("Priya", forKey: 1)                 //using updateValue Method
print(myDict3)

myDict3[1] = "NewVlaue"
print(myDict3)

//Remove Value in Dictionary

myDict3.removeValueForKey(1)
print(myDict3)

/* NSDICTIONARY AND NSMUTABLE DICTIONARY */

var myNewDict1:NSDictionary = ["One":"Sharad"];
var myNewDict2 = NSDictionary.init(dictionary: ["One":"Sharad","Two":"Nagendra"])


/***** END OF DICTIONARY *****/
/*-------------------------------------------------------------------------------------------------------------*/

/**** FUNCTIONS *****/
/*Function Parameters also called as Tuples
    Syntax :  Accessor Type  func func_Name(arg_name: arg_type) -> returnType{
                                //Func_Definition
                        }
*/
//Decalration and Defining with Void return type
func myFirstFunction() -> Void{
    let a=10
    let b=20;
    print(a + b)
}
myFirstFunction()

//print(myFirstFunction())                                //Calling Function


//Declaring Function with Parameter and return Type
func mySecondFuction(name: String) -> NSString{
    return name;
}
print("My String :", mySecondFuction("Adeptpros"))


//Declaring  Function with Return Values (Returning Mpre than one Value)
func thirdFuction(name1:String,name2:String) -> (n1:String,n2:String){
    return (name1,name2)
}
var tupleValue = thirdFuction("Adeptpros", name2: "GeniusPot")
print("Name1:\(tupleValue.n1) and Name2:\(tupleValue.n2)")

func getLargeAndSmallValue(array:[Int]) -> (large:Int, small:Int){
    var lar = array[0]
    var sm = array[0]
    for i in array[1..<array.count]{
        if i < sm {
            sm = i
        } else if i > lar {
            lar = i
        }
    }
    return (lar, sm)
}
var ls = getLargeAndSmallValue([10,5,30,40])
print("Large :\(ls.large) Small:\(ls.small)")


//Declaring Function with parameter passing set of Values or as single Value

func myfunctionWithArray(numbers:String...) ->String{
    
    var sum = ""
    for value in numbers{
        sum += value
    }
    return sum
}
print(myfunctionWithArray("Adeptpros"))
print(myfunctionWithArray("Adeptpros","Geniusport"))

//Declaring Function inside another function (Nested function)

func mainFucntionAction(name: String) -> Void{
    
    func nestedFunctionAction() ->NSString{
        
        return name
    }
    print(nestedFunctionAction())
}

print(mainFucntionAction("Sharad"))


//Function as  argument to another Function

func lessThan(number:Int) -> Bool {
    return number < 10
}
func hasFunctionParameter(numbers:[Int], condition:(Int) ->Bool)->Bool{
    
    for item in numbers{
        if condition(item){
            return true
        }
    }
    return false
}
print(hasFunctionParameter([30,9,20,10], condition: lessThan))

/*-------------------------------------------------------------------------------------------------------------*/

/**** CLOSURE / BLOCKS ****/

/*** Closure Encloses these three properties
1. Global functions are closures that have a name and do not capture any values.
2. Nested functions are closures that have a name and can capture values from their enclosing function.
3. Closure expressions are unnamed closures written in a lightweight syntax that can capture values from their surrounding context.
*/

/* Closure Provides cut free Syntax
A. Inferring parameter and return value types from context
B. Implicit returns from single-expression closures
C. Shorthand argument names
D. Trailing closure syntax

    1. Closure Expression
            { (param-type: param_name1..) -> return type in
                statements
            }
    2. Inferring Type From Context
            { (param_name) -> return type in
                statements
            }

*/
//-------------------------------------------------------------
//1.Example  Passing function as Closure to another function
let myarray=["Sharad","Nagendra","Arjun"];
func backwards(string1:String, secondString:String) -> Bool{
    
    return string1 > secondString
}
var mySortedArray1 = myarray.sort(backwards)          //backwards function acts as closure to the .Sort() function
print(mySortedArray1)

//2. Example - Closure Defination as Function Parameter (Closure Expression)
var mySortedArray2 = myarray.sort({(firstString:String, secondString:String) ->Bool in
    
    return firstString > secondString

})
print(mySortedArray2)

/* 3.  Example - Closure Defination as Function Parameter (Closure Expression With Inferring Type From Context)
  Note: To infer the parameter types and return type when passing a closure to a function or method
        as an inline closure expression. As a result, you never need to write an inline closure in its
        fullest form when the closure is used as a function or method argument.
*/
var mySortedArray3 = myarray.sort({(firstString, secondString) in
    
    return firstString > secondString
    
})
print(mySortedArray3)

// 4. Example - Implicit Returns from Single-Expression Closures
var mySortedArray4 = myarray.sort({(firstString, secondString) in
    
    firstString > secondString                  //No need of return keyword is closure is returning single value
    
})
print(mySortedArray4)

/* 5. Example - Shorthand Argument Names in Closure Expression
    Note: Swift automatically provides shorthand argument names to inline closures, which can be used to refer 
          to the values of the closure’s arguments by the names $0, $1, $2, and so on.
*/
var mySortedArray5 = myarray.sort({
    $0 > $1
})
print(mySortedArray5)

// 6. Operator Functions (simply pass in the greater-than operator,internaly it uses its string-specific implementation)
var mySortedArray6 = myarray.sort(>)
print(mySortedArray6)

/* 7. Example - Trailing Closure
   1. A trailing closure is a closure expression that is written outside of (and after) the parentheses of the
        function call it supports,i.e., u can define clousre body after the function call rather then pasing it in
        function
    
    Syntax:          method_name(){
                        
                       // closure body
                    }
    2. If closure expression is provided as function/method parameter only and if user declare the closure expression
        as trailing closure then no need of using paranthesis for the function which performing closure.

    Syntax:             method_name {
                        //closure body
                        }
*/
var mySortedArray7 = myarray.sort(){
    
        $0 > $1
}
print(mySortedArray7)

var mySortedArray8 = myarray.sort{ $0 > $1 }
print(mySortedArray8)

//Example for Closure Expression with the default method of array to enumerates the values of Array
let digitNames = [  0: "Zero",
                    1: "One",
                    2: "Two",
                    3: "Three",
                    4: "Four",
                    5: "Five",
                    6: "Six",
                    7: "Seven",
                    8: "Eight",
                    9: "Nine"
                 ]                                              //Dictionary
let numbers = [16, 58, 510]                                     //Array

//Maping the Array values with Closure Expression where parameter number which contain the each value of array.
// array.map() -> returns mapped out array values and stores in newArray
let strings = numbers.map { (var number) -> String in           //Closure Expression with return Value
    //Closure Body
    var output = ""                                             //Storing the value from the dictionary each time its looping
    while number > 0 {
        output = digitNames[number % 10]! + output              //retreving value from dictionary and appending to output Variable
        number /= 10
    }
    return output
}
print(strings)

//Capturing Value
//Closures Are Reference Types
//Nonescaping Closure
//Autoclosure

/**** END OF CLOSURE / BLOCK *****/

/*--------------------------------------------------------------------------------------------------------------------------------*/

/**** ENUMERATION ******/
/* Syntax:

            enum SomeEnumeration {
                // enumeration definition goes here
            }
*/
//Enumeration Declaration
enum myDirectionEnum{

    case North
    case South
    case West
    case East
}
print(myDirectionEnum.South)

//Matching Enumeration with Switch Case
var checkValue = myDirectionEnum.North
switch checkValue {
case .North:
    print("Lots of planets have a north")
case .South:
    print("Watch out for penguins")
case .East:
    print("Where the sun rises")
case .West:
    print("Where the skies are blue")
}

//Enum with Associates Values

//Enum with Raw Values
//Implicit Associated Raw Values
//Initializing from Raw Value
//Recursive Enumeration

/***** END OF ENUMERATION *****/

/*--------------------------------------------------------------------------------------------------------------------------------*/

/***** STRUCTURES ******/

/***** END OF STRUCTURES *****/

/*--------------------------------------------------------------------------------------------------------------------------------*/

/******* CLASSES AND OBJECTS ******/

class myFirstClass{
    
    var myVar1 = 10;
    var myString:String?
    
   private func myClassFunction(num1:Int, num2:Int) -> Void{
        print(num1 + num2)
    }
}
let obj = myFirstClass()
obj.myClassFunction(10, num2: 10)
print(obj.myVar1)

/***** Inheritance/Polymorphism ******/

class Area{
    
    func areaOfShapes() -> String{
        return "Area of Shapes"
    }
    
}

class Circle: Area{                                     //Inheritance
    
    var radiusOfCircle:Float = 0
    init(radiusOfCircle : Float){
        self.radiusOfCircle = radiusOfCircle
    }
    var myPropertyVariable: Float{
        get{
            return 10;
        }
        set {
            radiusOfCircle = newValue        //newValue Predefine Variable
        }
    }
    override func areaOfShapes() -> String {            //Overriding the Function
        print(super.areaOfShapes())                     //Calling Parent Class function
        return String(2 * 3.143 * radiusOfCircle)
    }
}

let circleObject = Circle(radiusOfCircle: 3.5)
print(circleObject.areaOfShapes())
print(circleObject.myPropertyVariable)
circleObject.myPropertyVariable = 50
print(circleObject.radiusOfCircle)
