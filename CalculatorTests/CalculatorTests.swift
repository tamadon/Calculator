//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by Natsuko Nishikata on 2018/10/04.
//  Copyright © 2018年 Natsuko Nishikata. All rights reserved.
//

import XCTest
@testable import Calculator

class CalculatorTests: XCTestCase {
    
    var calculator:Calculator?
    
    private func inputString(_ string:String) -> CalculateError {
        return inputString(string, withInitialValue: nil)
    }
  
    private func inputString(_ string:String, withInitialValue initialValue:Int?) -> CalculateError {
        if let value = initialValue {
            calculator = Calculator(intValue: value)
        }
        let errors = string
            .map { calculator?.input(text: String($0)) }
            .filter { $0 != .noError }
        
        return errors.count == 0 ? .noError : errors[0]!
    }
    
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let err = inputString("1+2=", withInitialValue: 0)
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString()=="3")
        XCTAssertTrue(calculator?.doubleValue()==3)
        
    }

    // MARK: 数字入力と表示
    func testInputDigit() {
        let err = inputString("123456789", withInitialValue: 0)
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "123,456,789")
        XCTAssertTrue(calculator?.doubleValue() == 123456789)
    }
    
    func testInputMaximumIntegerDigits() {
        let err = inputString("12345678901234", withInitialValue: 0)
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "12,345,678,901,234")
        XCTAssertTrue(calculator?.doubleValue() == 12345678901234)
    }
    
    func testInputOverflowDigits() {
        let err = inputString("123456789012345", withInitialValue: 0)
        XCTAssertTrue(err == .inputOverflow)
    }

    // MARK: 演算
    func testPlus() {
        var err = inputString("1+2", withInitialValue: 0)
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "2")
        XCTAssertTrue(calculator?.doubleValue() == 2)
        
        err = inputString("=")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "3")
        XCTAssertTrue(calculator?.doubleValue() == 3)
    }
    
    func testMinus() {
        var err = inputString("10-2", withInitialValue: 0)
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "2")
        XCTAssertTrue(calculator?.doubleValue() == 2)
        err = inputString("=")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "8")
        XCTAssertTrue(calculator?.doubleValue() == 8)
    }

    func testMultipliedBy() {
        var err = inputString("5*2", withInitialValue: 0)
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "2")
        XCTAssertTrue(calculator?.doubleValue() == 2)

        err = inputString("=")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "10")
        XCTAssertTrue(calculator?.doubleValue() == 10)
    }
    
    func testDividedBy() {
        var err = inputString("20/2", withInitialValue: 0)
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "2")
        XCTAssertTrue(calculator?.doubleValue() == 2)

        err = inputString("=")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "10")
        XCTAssertTrue(calculator?.doubleValue() == 10)
    }
    
    // MARK: 複合計算
    func testCalculate() {
        var err = inputString("10+", withInitialValue: 0)
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "10")
        XCTAssertTrue(calculator?.doubleValue() == 10)

        err = inputString("5")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "5")
        XCTAssertTrue(calculator?.doubleValue() == 5)

        err = inputString("-")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "15")
        XCTAssertTrue(calculator?.doubleValue() == 15)

        err = inputString("3")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "3")
        XCTAssertTrue(calculator?.doubleValue() == 3)

        err = inputString("*")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "12")
        XCTAssertTrue(calculator?.doubleValue() == 12)

        err = inputString("2")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "2")
        XCTAssertTrue(calculator?.doubleValue() == 2)

        err = inputString("/")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "24")
        XCTAssertTrue(calculator?.doubleValue() == 24)

        err = inputString("3")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "3")
        XCTAssertTrue(calculator?.doubleValue() == 3)

        err = inputString("=")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "8")
        XCTAssertTrue(calculator?.doubleValue() == 8)
    }
    
    // MARK: 演算子の連続入力
    func testInputDoubleOperator() {
        var err = inputString("10+", withInitialValue: 0)
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "10")
        XCTAssertTrue(calculator?.doubleValue() == 10)

        err = inputString("5")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "5")
        XCTAssertTrue(calculator?.doubleValue() == 5)

        err = inputString("-")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "15")
        XCTAssertTrue(calculator?.doubleValue() == 15)

        err = inputString("+")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "15")
        XCTAssertTrue(calculator?.doubleValue() == 15)

        err = inputString("5")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "5")
        XCTAssertTrue(calculator?.doubleValue() == 5)

        err = inputString("=")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "20")
        XCTAssertTrue(calculator?.doubleValue() == 20)
    }
    
    // MARK: 連続計算
    func testContinuousCalculation() {
        var err = inputString("4+6=", withInitialValue: 0)
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "10")
        XCTAssertTrue(calculator?.doubleValue() == 10)

        err = inputString("+")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "10")
        XCTAssertTrue(calculator?.doubleValue() == 10)

        err = inputString("2=")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "12")
        XCTAssertTrue(calculator?.doubleValue() == 12)
    }
    
    // MARK: 特殊入力
    func testStartWithOperator() {
        var err = inputString("+", withInitialValue: 0)
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "0")
        XCTAssertTrue(calculator?.doubleValue() == 0)

        err = inputString("2=")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "2")
        XCTAssertTrue(calculator?.doubleValue() == 2)

        err = inputString("*")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "2")
        XCTAssertTrue(calculator?.doubleValue() == 2)

        err = inputString("2=")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "4")
        XCTAssertTrue(calculator?.doubleValue() == 4)
    }
    
    func testStartWithEqual() {
        var err = inputString("=", withInitialValue: 0)
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "0")
        XCTAssertTrue(calculator?.doubleValue() == 0)
        
        err = inputString("100=")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "100")
        XCTAssertTrue(calculator?.doubleValue() == 100)
        
        err = inputString("*")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "100")
        XCTAssertTrue(calculator?.doubleValue() == 100)
        
        err = inputString("2=")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "200")
        XCTAssertTrue(calculator?.doubleValue() == 200)
    }
    
    // MARK: 境界値
    func testOverflow() {
        let err = inputString("99999999*99999999=", withInitialValue: 0)
        XCTAssertTrue(err == .calculateOverflow)
    }
    
    func testUnderflow() {
        let err = inputString("-2=", withInitialValue: 0)
        XCTAssertTrue(err == .negativeValue)
    }
    
    // MARK: 初期値ありの入力
    func testInputDigitWithInitialValue() {
        let err = inputString("12345", withInitialValue: 4)
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "12,345")
        XCTAssertTrue(calculator?.doubleValue() == 12345)
    }
    
    func testInputMaximumIntegerDigitsWithInitialValue() {
        let err = inputString("12345678901234", withInitialValue: 100)
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "12,345,678,901,234")
        XCTAssertTrue(calculator?.doubleValue() == 12345678901234)
    }
    
    func testInputOverflowDigitsWithInitialValue() {
        let err = inputString("123456789012345", withInitialValue: 100)
        XCTAssertTrue(err == .inputOverflow)
    }
    
    // MARK: 初期値ありの計算
    func testCalculateWithInitialValue() {
        var err = inputString("10+", withInitialValue: 100)
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "10")
        XCTAssertTrue(calculator?.doubleValue() == 10)
        
        err = inputString("5")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "5")
        XCTAssertTrue(calculator?.doubleValue() == 5)
        
        err = inputString("-")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "15")
        XCTAssertTrue(calculator?.doubleValue() == 15)
        
        err = inputString("3")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "3")
        XCTAssertTrue(calculator?.doubleValue() == 3)
        
        err = inputString("*")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "12")
        XCTAssertTrue(calculator?.doubleValue() == 12)
        
        err = inputString("2")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "2")
        XCTAssertTrue(calculator?.doubleValue() == 2)
        
        err = inputString("/")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "24")
        XCTAssertTrue(calculator?.doubleValue() == 24)
        
        err = inputString("3")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "3")
        XCTAssertTrue(calculator?.doubleValue() == 3)
        
        err = inputString("=")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "8")
        XCTAssertTrue(calculator?.doubleValue() == 8)
    }
    
    // MARK: 初期値ありの特殊入力
    func testStartWithOperatorWithInitialValue() {
        var err = inputString("+", withInitialValue: 100)
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "100")
        XCTAssertTrue(calculator?.doubleValue() == 100)
        
        err = inputString("100=")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "200")
        XCTAssertTrue(calculator?.doubleValue() == 200)
        
        err = inputString("*")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "200")
        XCTAssertTrue(calculator?.doubleValue() == 200)
        
        err = inputString("2=")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "400")
        XCTAssertTrue(calculator?.doubleValue() == 400)
    }
    
    func testStartWithEqualWithInitialValue() {
        var err = inputString("=", withInitialValue: 100)
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "100")
        XCTAssertTrue(calculator?.doubleValue() == 100)
        
        err = inputString("100=")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "100")
        XCTAssertTrue(calculator?.doubleValue() == 100)
        
        err = inputString("*")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "100")
        XCTAssertTrue(calculator?.doubleValue() == 100)
        
        err = inputString("2=")
        XCTAssertTrue(err == .noError)
        XCTAssertTrue(calculator?.displayString() == "200")
        XCTAssertTrue(calculator?.doubleValue() == 200)
    }
    
  
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            _ = inputString("1+2*10/3+5=", withInitialValue: 0)
        }
    }

}
