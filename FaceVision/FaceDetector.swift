//
//  FaceDetector.swift
//  FaceVision
//
//  Created by Igor K on 6/7/17.
//  Copyright © 2017 Igor K. All rights reserved.
//

import UIKit
import Vision

class FaceDetector {
    
    func highlightFaces(for source: UIImage, complete: @escaping (UIImage) -> ()) -> [Float] {
        var resultImage = source
        var arr: [Float] = []
//        var ret:
        
        print("REEE")
        let detectFaceRequest = VNDetectFaceLandmarksRequest { (request, error) in
            print("TUUF")
            if error == nil {
                print("FEEE")
                if let results = request.results as? [VNFaceObservation] {
                    print("Found \(results.count) faces")
                    
                    for faceObservation in results {
                        guard let landmarks = faceObservation.landmarks else {
                            continue
                        }
                        let boundingRect = faceObservation.boundingBox
                        print("_________")
                        arr.append(Float(boundingRect.maxX))
                        arr.append(Float(boundingRect.minX))
                        arr.append(Float(boundingRect.maxY))
                        arr.append(Float(boundingRect.minY))
                        
                        //let uuid = faceObservation.uuid
                        //let conf = faceObservation.confidence
                        var landmarkRegions: [VNFaceLandmarkRegion2D] = []
                        if let leftEye = landmarks.leftEye {
                            landmarkRegions.append(leftEye)
                            print(landmarkRegions)
                        }
                        for val in landmarkRegions{
                            print(val)
                        }
                        if let rightEye = landmarks.rightEye {
                            landmarkRegions.append(rightEye)
                            print(landmarkRegions)
                        }
                        
                        for faceLandmarkRegion in landmarkRegions {
                            var max_x = CGFloat(0);
                            var max_y = CGFloat(0);
                            var min_x = CGFloat(0);
                            var min_y = CGFloat(0);
                            
                            var points: [CGPoint] = []
                            for i in 0..<faceLandmarkRegion.pointCount {
                                let point = faceLandmarkRegion.normalizedPoints[i]
                                if(point.x>max_x){
                                    max_x = point.x
                                }
                                if(point.y>max_y){
                                    max_y = point.y
                                }
                                
                                arr.append(Float(max_x))
                                arr.append(Float(max_y))
                                
                                if(point.x<min_x){
                                    min_x = point.x
                                }
                                if(point.y<min_y){
                                    min_y = point.y
                                }
                                
                                arr.append(Float(min_x))
                                arr.append(Float(min_y))
                            }
                            
                            print("**")
                        }
//                        ret = arr
                        /*
                         if let leftEyebrow = landmarks.leftEyebrow {
                         landmarkRegions.append(leftEyebrow)
                         }
                         if let rightEyebrow = landmarks.rightEyebrow {
                         landmarkRegions.append(rightEyebrow)
                         }
                         
                         if let innerLips = landmarks.innerLips {
                         landmarkRegions.append(innerLips)
                         }
                         if let leftPupil = landmarks.leftPupil {
                         landmarkRegions.append(leftPupil)
                         }
                         if let rightPupil = landmarks.rightPupil {
                         landmarkRegions.append(rightPupil)
                         }*/
                        
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
            complete(resultImage)
        }
        // Create a request handler.
        
        let imageRequestHandler = VNImageRequestHandler(cgImage: source.cgImage!)
        // Send the requests to the request handler.
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try imageRequestHandler.perform([detectFaceRequest as VNRequest])
            } catch let error as NSError {
                print("Failed to perform image request: \(error)")
//                self.presentAlert("Image Request Failed", error: error)
                fatalError("Image Request Failed \(error)")
                return
            }
        }
        return arr
    }
}
