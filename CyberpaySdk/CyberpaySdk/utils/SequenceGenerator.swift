//
//  SequenceGenerator.swift
//  CyberpaySdk
//
//  Created by Sunday Okpoluaefe on 12/9/19.
//  Copyright © 2019 cyberspace. All rights reserved.
//

import Foundation
import CoreData
/**
 Generates a 63 bit integers for use in database primary keys. The value is k-ordered by time and has the following layout:
 - 41 bits timestamp with custom epoch
 - 12 bits sequence number
 - 10 bits instance ID
 */
public class SequenceGenerator {
    
    static let customEpoch : TimeInterval = {
        // custom epoch is 1 March 2018 00:00 UTC
        let utc = TimeZone(identifier: "UTC")!
        let cal = Calendar(identifier: .iso8601)
        var markerDate = DateComponents()
        markerDate.calendar = cal
        markerDate.timeZone = utc
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        markerDate.year = components.year
        markerDate.month = components.month
        markerDate.day = components.day
        return markerDate.date!.timeIntervalSinceReferenceDate
        
    }()
    
    static let limitInstanceNumber = UInt16(0x400)
    
    var lastGenerateTime = Int64(0)
    
    var instanceNumber : UInt16
    
    var sequenceNumber = UInt16(0)
    
    public init(instanceNumber: Int) {
        self.instanceNumber = UInt16(instanceNumber % Int(SequenceGenerator.limitInstanceNumber))
    }
    
    /**
     Generates the next identifier value.
     */
    public func nextValue() -> Int64 {
        let now = Date.timeIntervalSinceReferenceDate
        let customEpoch = SequenceGenerator.customEpoch
        var generateTime = Int64(floor( (now - customEpoch) * 1000) )

        let sequenceNumberMax = 0x1000
        if generateTime > lastGenerateTime {
            lastGenerateTime = generateTime
            sequenceNumber = 0
        } else {
            if generateTime < lastGenerateTime {
                // timestamp went backwards, probably because of NTP resync.
                // we need to keep the sequence number go forward
                generateTime = lastGenerateTime
            }
            sequenceNumber += 1
            if sequenceNumber == sequenceNumberMax {
                sequenceNumber = 0
                // we overflowed the sequence number, bump the overflow into the time field
                generateTime += 1
                lastGenerateTime = generateTime
            }
        }
        
        /*
         Value is
         - 41 bits timestamp with custom epoch
         - 12 bits sequence number
         - 10 bits instance ID
         */
        return (generateTime << 22) | (Int64(sequenceNumber & 0xFFF) << 10) | Int64(instanceNumber & (SequenceGenerator.limitInstanceNumber-1))
    }
}

// MARK: Hashable
extension SequenceGenerator: Hashable {
    public var hashValue: Int {
        get {
            return Int(instanceNumber)
        }
    }
}

public func ==(lhs: SequenceGenerator, rhs: SequenceGenerator) -> Bool {
    return lhs.instanceNumber == rhs.instanceNumber && lhs.lastGenerateTime == rhs.lastGenerateTime && lhs.sequenceNumber == rhs.sequenceNumber
}

/**
 A `SequenceGenerator` with automatically managed instance ID values.
 This class automatically manages the instance number from a process-wide pool of instance numbers and returning
 identifiers to the pool when as objects get deallocated.
 Either use `InProcessSequenceGenerator` exclusively or its superclass `SequenceGenerator` exclusively but not both
 since the instance ID values are obtained from the same pool of integer ranges.
 Note that the maximum number of instances at any given moment is 1024 for a process. Otherwise init() would
 crash due to running out of instance numbers.
 */
public class InProcessSequenceGenerator : SequenceGenerator {
    
    /**
     The set of instance numbers that are still available.
     */
    
    static var availableInstanceNumbers = IndexSet(integersIn: 0..<Int(UInt16(0x400)))
    static let classQueue = DispatchQueue(label: "cyberpay.sdk.InProcessSequenceGenerator")
    
    /**
     Returns the number of instances that may still be created
     */
    public static var instancesAvailable : Int {
        get {
            return classQueue.sync {
                return availableInstanceNumbers.count
            }
        }
    }
    
    override private init(instanceNumber: Int) {
        fatalError("Do not specify instance number when constructing InProcessSequenceGenerator")
    }
    
    /**
     Creates a generator instance with randomly-selected instance number.
     This would fail if there are no more instance numbers left (there are a global limit of 1024 instance numbers
     available at any given time.
     */
    public init?() {
        let starterNumber = Int(arc4random_uniform(UInt32((UInt16(0x400)))))
        let ownType = type(of:self)
        guard let num = ownType.classQueue.sync(execute:{
            () -> Int? in
            guard let selectedNum = (
                    ownType.availableInstanceNumbers.integerLessThanOrEqualTo(starterNumber) ??
                    ownType.availableInstanceNumbers.integerGreaterThan(starterNumber)
                ) else {
                    return nil
            }
            ownType.availableInstanceNumbers.remove(selectedNum)
            return selectedNum
        }) else {
            return nil
        }
        super.init(instanceNumber:num)
    }
    
    deinit {
        let returnedInstanceNumber = Int(instanceNumber)
        let ownType = type(of:self)
        _ = ownType.classQueue.sync {
            ownType.availableInstanceNumbers.update(with: returnedInstanceNumber)
        }
    }
    
    /**
     Returns the ID generator for the current thread, or create a new one if it doesn't exists.
     The generator instance is placed inside the `threadDictionary` of the current thread.
     */
    static func SequenceGenerator(thread: Thread) -> SequenceGenerator  {
        let objectName = "cyberpay.sdk.SequenceGenerator.thread"
        let threadDict = thread.threadDictionary
        if let existingSequenceGenerator = threadDict[objectName] as? InProcessSequenceGenerator {
            return existingSequenceGenerator
        }
        let fm = InProcessSequenceGenerator()!
        threadDict[objectName] = fm
        return fm
    }
}

public extension Thread {
    /**
     Returns the next ID for the current thread. Creates an ID generator if necessary in the thread-local storage.
     */
    @objc func nextSequenceId() -> Int64 {
        return InProcessSequenceGenerator.SequenceGenerator(thread:self).nextValue()
    }
}




extension InProcessSequenceGenerator {
    /**
     Returns the ID generator for the specified managed object context.
     */
    static func sequenceMaker(managedObjectContext: NSManagedObjectContext) -> SequenceGenerator {
        let objectName = "cyberpay.sdk.Generator.managedObjectContext"
        let userInfo = managedObjectContext.userInfo
        if let maker = userInfo[objectName] as? InProcessSequenceGenerator {
            return maker
        }
        let fm = InProcessSequenceGenerator()!
        userInfo[objectName] = fm
        return fm
    }
}

public extension NSManagedObjectContext {
    /**
     Returns the next ID for the managed object context. Creates an ID generator if necessary in the `userInfo` dictionary.
     */
    @objc func nextSequenceId() -> Int64 {
        return InProcessSequenceGenerator.sequenceMaker(managedObjectContext:self).nextValue()
    }
}
