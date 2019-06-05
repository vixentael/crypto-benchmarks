//
//  ViewController.swift
//  CryptoBenchmark
//
//  Created by Anastasiia on 6/5/19.
//  Copyright © 2019 Cossack Labs. All rights reserved.
//

import UIKit
import CryptoKit
import themis

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let smallData = [32, 45, 100, 800, 1024]
//        let mediumData = [1024, 2*1024, 10*1024, 1024*1024, 2*1024*1024, 3*1024*1024]
//        let mixedDataLength = [32, 45, 100, 800, 1024, 2*1024, 10*1024, 1024*1024, 2*1024*1024, 3*1024*1024]
//
//        print("Benchmarking small data (32 bytes ... 1 kB)")
//        benchMarkingData1(dataLength: smallData, steps: 10, innerSteps: 100)
//
//        print("Benchmarking large data (1kB ... 3 MB)")
//        benchMarkingData1(dataLength: mediumData, steps: 10, innerSteps: 100)
//
//        print("Benchmarking mixed data (32 bytes ... 3 MB)")
//        benchMarkingData1(dataLength: mixedDataLength, steps: 10, innerSteps: 100)
//
//        print("---------------------")
        
        let smallData2 = [10, 32, 45, 100, 300, 500, 800, 1024]
        let mediumData2 = [1024, 2*1024, 5*1024, 10*1024, 100*1024, 1024*1024, /*2*1024*1024, 3*1024*1024*/]

        print("Benchmarking2 small data (32 bytes ... 1 kB)")
        benchMarkingData2(dataLength: smallData2, innerSteps: 1000)

        print("Benchmarking2 large data (1kB ... 3 MB)")
        benchMarkingData2(dataLength: mediumData2, innerSteps: 1000)
        
//
//        let mediumData2 = [1024*1024, 2*1024*1024, 3*1024*1024]
//        benchMarkingData2(dataLength: mediumData2, innerSteps: 1000)
    }
    
    func benchMarkingData2(dataLength: [Int], innerSteps: Int) {
        var cryptoKitBenchMarks: [Double] = []
        var themisBenchMarks: [Double] = []
        
        for step in 0...dataLength.count-1 {
            autoreleasepool {
                // prepare data piece
                let data = randomData(ofLength: dataLength[step])
                
                // loop starts for CryptoKit
                let startTimeCK = CACurrentMediaTime()
                for _ in 1...innerSteps {
                    autoreleasepool {
                        cryptoKitEncryptionDecryption(message: data)
                    }
                }
                let timeElapsedCK = CACurrentMediaTime() - startTimeCK
                print("CryptoKit\t\(step)\t" + "\(timeElapsedCK)")
                cryptoKitBenchMarks.append(timeElapsedCK)
                
                // loop starts for Themis
                let startTimeTh = CACurrentMediaTime()
                for _ in 1...innerSteps {
                    autoreleasepool {
                        themisEncryptionDecryption(message: data)
                    }
                }
                let timeElapsedTh = CACurrentMediaTime() - startTimeTh
                print("Themis\t\(step)\t" + "\(timeElapsedTh)")
                themisBenchMarks.append(timeElapsedTh)
            }
        }
        
        print("CryptoKit\t" + "\(cryptoKitBenchMarks.map({"\($0)"}).joined(separator:"\t"))")
        print("Themis\t" + "\(themisBenchMarks.map({"\($0)"}).joined(separator:"\t"))")
    }
    
    func benchMarkingData1(dataLength: [Int], steps: Int, innerSteps: Int) {
        var cryptoKitBenchMarks: [Double] = []
        var themisBenchMarks: [Double] = []
        
        for step in 1...steps {
            
            // prepare data pieces
            var dataPieces: [Data] = []
            for length in dataLength {
                dataPieces.append(randomData(ofLength: length))
            }
            autoreleasepool {
                // loop starts for CryptoKit
                let startTimeCK = CACurrentMediaTime()
                for _ in 1...innerSteps {
                    for data in dataPieces {
                        cryptoKitEncryptionDecryption(message: data)
                    }
                }
                let timeElapsedCK = CACurrentMediaTime() - startTimeCK
                print("CryptoKit\t\(step)\t" + "\(timeElapsedCK)")
                cryptoKitBenchMarks.append(timeElapsedCK)
                
                // loop starts for Themis
                let startTimeTh = CACurrentMediaTime()
                for _ in 1...innerSteps {
                    for data in dataPieces {
                        themisEncryptionDecryption(message: data)
                    }
                }
                let timeElapsedTh = CACurrentMediaTime() - startTimeTh
                print("Themis\t\(step)\t" + "\(timeElapsedTh)")
                themisBenchMarks.append(timeElapsedTh)
            }
        }
        
        print("CryptoKit\t" + "\(cryptoKitBenchMarks.map({"\($0)"}).joined(separator:"\t"))")
        print("Themis\t" + "\(themisBenchMarks.map({"\($0)"}).joined(separator:"\t"))")
    }
    
    func themisEncryptionDecryption(message: Data) {
        let masterKey = "any strng because themis has kdf"
        
        let cellSeal = TSCellSeal(key: masterKey.data(using: .utf8)!)!
        let encrypted = try! cellSeal.wrap(message, context: nil)
        let decrypted = try! cellSeal.unwrapData(encrypted, context: nil)
        
        //assert(decrypted == message)
    }

    func cryptoKitEncryptionDecryption(message: Data) {
        let key = SymmetricKey(size: .bits256)
        
        let sealedBox = try! AES.GCM.seal(message, using: key)
        let decrypted = try! AES.GCM.open(sealedBox, using: key)
        
        //assert(decrypted == message)
    }
    
    func randomData(ofLength length: Int) -> Data {
        var bytes = [UInt8](repeating: 0, count: length)
        let status = SecRandomCopyBytes(kSecRandomDefault, length, &bytes)
        if status == errSecSuccess {
            return Data(_: bytes)
        }
        assert(false) // let's just stop running here
    }
}

