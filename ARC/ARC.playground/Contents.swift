import Foundation

class Component: CustomDebugStringConvertible {

    var debugDescription: String { "component" }

    deinit {
        print("I have no references, I'm free to go!")
    }

}

struct ValueTypeComponent: CustomDebugStringConvertible {

    var debugDescription: String { "value type component" }

}


class ClassWithValueType: CustomDebugStringConvertible {

    var debugDescription: String { "class with value type" }

    let valueType: ValueTypeComponent = ValueTypeComponent()
}


struct ValueTypeWithClass: CustomDebugStringConvertible {

    var debugDescription: String { "value type with class" }

    let reference: Component = Component()

}


func getReferenceCount(_ object: CFTypeRef) {
    print("-------------------")
    print("number of references for: \(object.debugDescription!): \(CFGetRetainCount(object))")
    print("-------------------")
}

//only strong references increment retain count
var component1: Component? = Component()

getReferenceCount(component1!)


var component2: Component? = component1
getReferenceCount(component1!)


// weak is not ++ retain count so even if there is a weak reference
// component will get deinitialized after all stron references are decremented
weak var component3: Component? = component1
getReferenceCount(component1!)


component2 = nil

getReferenceCount(component1!)

component3 = nil

getReferenceCount(component1!)

component1 = nil

//getReferenceCount(component1!) // Component got deallocated, we get an error


var component4: ValueTypeComponent? = ValueTypeComponent()

getReferenceCount(component4 as CFTypeRef)

var component5 = component4

getReferenceCount(component4 as CFTypeRef)
getReferenceCount(component5 as CFTypeRef)

component4 = nil

getReferenceCount(component4 as CFTypeRef)
getReferenceCount(component5 as CFTypeRef)


let class1 = ClassWithValueType()

//getReferenceCount(class1)
//getReferenceCount(class1.valueType as CFTypeRef)

print("number of references for: \(class1.debugDescription): \(CFGetRetainCount(class1))")
print("number of references for: \(class1.debugDescription): \(CFGetRetainCount(class1.valueType as CFTypeRef))")


let class2 = class1

print("number of references for: \(class1.debugDescription): \(CFGetRetainCount(class1))")
print("number of references for: \(class1.debugDescription): \(CFGetRetainCount(class1.valueType as CFTypeRef))")

getReferenceCount(class1) // passing object as argument increses reference count but after local scope ends it's decreased

print("number of references for: \(class1.debugDescription): \(CFGetRetainCount(class1))")
print("number of references for: \(class1.debugDescription): \(CFGetRetainCount(class1.valueType as CFTypeRef))")


let valueWithClass = ValueTypeWithClass()

print("number of references for: \(valueWithClass.debugDescription): \(CFGetRetainCount(valueWithClass as CFTypeRef))")
print("number of references for: \(valueWithClass.debugDescription): \(CFGetRetainCount(valueWithClass.reference as CFTypeRef))")


let valueWithClass2 = valueWithClass

print("number of references for: \(valueWithClass.debugDescription): \(CFGetRetainCount(valueWithClass as CFTypeRef))")
print("number of references for: \(valueWithClass.debugDescription): \(CFGetRetainCount(valueWithClass.reference as CFTypeRef))")
