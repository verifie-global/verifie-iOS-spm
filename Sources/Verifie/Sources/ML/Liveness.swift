//
// Liveness.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class LivenessInput : MLFeatureProvider {

    /// image as color (kCVPixelFormatType_32BGRA) image buffer, 64 pixels wide by 64 pixels high
    var image: CVPixelBuffer

    var featureNames: Set<String> {
        get {
            return ["image"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "image") {
            return MLFeatureValue(pixelBuffer: image)
        }
        return nil
    }
    
    init(image: CVPixelBuffer) {
        self.image = image
    }


    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    convenience init(imageWith image: CGImage) throws {
        let __image = try MLFeatureValue(cgImage: image, pixelsWide: 64, pixelsHigh: 64, pixelFormatType: kCVPixelFormatType_32BGRA, options: nil).imageBufferValue!
        self.init(image: __image)
    }


    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    convenience init(imageAt image: URL) throws {
        let __image = try MLFeatureValue(imageAt: image, pixelsWide: 64, pixelsHigh: 64, pixelFormatType: kCVPixelFormatType_32BGRA, options: nil).imageBufferValue!
        self.init(image: __image)
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func setImage(with image: CGImage) throws  {
        self.image = try MLFeatureValue(cgImage: image, pixelsWide: 64, pixelsHigh: 64, pixelFormatType: kCVPixelFormatType_32BGRA, options: nil).imageBufferValue!
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func setImage(with image: URL) throws  {
        self.image = try MLFeatureValue(imageAt: image, pixelsWide: 64, pixelsHigh: 64, pixelFormatType: kCVPixelFormatType_32BGRA, options: nil).imageBufferValue!
    }
}


/// Model Prediction Output Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class LivenessOutput : MLFeatureProvider {

    /// Source provided by CoreML

    private let provider : MLFeatureProvider


    /// output1 as dictionary of strings to doubles
    lazy var output1: [String : Double] = {
        [unowned self] in return self.provider.featureValue(for: "output1")!.dictionaryValue as! [String : Double]
    }()

    /// classLabel as string value
    lazy var classLabel: String = {
        [unowned self] in return self.provider.featureValue(for: "classLabel")!.stringValue
    }()

    var featureNames: Set<String> {
        return self.provider.featureNames
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        return self.provider.featureValue(for: featureName)
    }

    init(output1: [String : Double], classLabel: String) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["output1" : MLFeatureValue(dictionary: output1 as [AnyHashable : NSNumber]), "classLabel" : MLFeatureValue(string: classLabel)])
    }

    init(features: MLFeatureProvider) {
        self.provider = features
    }
}


/// Class for model loading and prediction
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class Liveness {
    let model: MLModel

    /// URL of model assuming it was installed in the same bundle as this class
    class var urlOfModelInThisBundle : URL {
        let bundle = Bundle(for: self)
        return bundle.url(forResource: "Liveness", withExtension:"mlmodelc")!
    }

    /**
        Construct Liveness instance with an existing MLModel object.

        Usually the application does not use this initializer unless it makes a subclass of Liveness.
        Such application may want to use `MLModel(contentsOfURL:configuration:)` and `Liveness.urlOfModelInThisBundle` to create a MLModel object to pass-in.

        - parameters:
          - model: MLModel object
    */
    init(model: MLModel) {
        self.model = model
    }

    /**
        Construct Liveness instance by automatically loading the model from the app's bundle.
    */
    @available(*, deprecated, message: "Use init(configuration:) instead and handle errors appropriately.")
    convenience init() {
        try! self.init(contentsOf: type(of:self).urlOfModelInThisBundle)
    }

    /**
        Construct a model with configuration

        - parameters:
           - configuration: the desired model configuration

        - throws: an NSError object that describes the problem
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    convenience init(configuration: MLModelConfiguration) throws {
        try self.init(contentsOf: type(of:self).urlOfModelInThisBundle, configuration: configuration)
    }

    /**
        Construct Liveness instance with explicit path to mlmodelc file
        - parameters:
           - modelURL: the file url of the model

        - throws: an NSError object that describes the problem
    */
    convenience init(contentsOf modelURL: URL) throws {
        try self.init(model: MLModel(contentsOf: modelURL))
    }

    /**
        Construct a model with URL of the .mlmodelc directory and configuration

        - parameters:
           - modelURL: the file url of the model
           - configuration: the desired model configuration

        - throws: an NSError object that describes the problem
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    convenience init(contentsOf modelURL: URL, configuration: MLModelConfiguration) throws {
        try self.init(model: MLModel(contentsOf: modelURL, configuration: configuration))
    }

    /**
        Construct Liveness instance asynchronously with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    class func load(configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<Liveness, Error>) -> Void) {
        return self.load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration, completionHandler: handler)
    }

    /**
        Construct Liveness instance asynchronously with URL of the .mlmodelc directory with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - modelURL: the URL to the model
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<Liveness, Error>) -> Void) {
        MLModel.__loadContents(of: modelURL, configuration: configuration) { (model, error) in
            if let error = error {
                handler(.failure(error))
            } else if let model = model {
                handler(.success(Liveness(model: model)))
            } else {
                fatalError("SPI failure: -[MLModel loadContentsOfURL:configuration::completionHandler:] vends nil for both model and error.")
            }
        }
    }

    /**
        Make a prediction using the structured interface

        - parameters:
           - input: the input to the prediction as LivenessInput

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as LivenessOutput
    */
    func prediction(input: LivenessInput) throws -> LivenessOutput {
        return try self.prediction(input: input, options: MLPredictionOptions())
    }

    /**
        Make a prediction using the structured interface

        - parameters:
           - input: the input to the prediction as LivenessInput
           - options: prediction options 

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as LivenessOutput
    */
    func prediction(input: LivenessInput, options: MLPredictionOptions) throws -> LivenessOutput {
        let outFeatures = try model.prediction(from: input, options:options)
        return LivenessOutput(features: outFeatures)
    }

    /**
        Make a prediction using the convenience interface

        - parameters:
            - image as color (kCVPixelFormatType_32BGRA) image buffer, 64 pixels wide by 64 pixels high

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as LivenessOutput
    */
    func prediction(image: CVPixelBuffer) throws -> LivenessOutput {
        let input_ = LivenessInput(image: image)
        return try self.prediction(input: input_)
    }

    /**
        Make a batch prediction using the structured interface

        - parameters:
           - inputs: the inputs to the prediction as [LivenessInput]
           - options: prediction options 

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as [LivenessOutput]
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    func predictions(inputs: [LivenessInput], options: MLPredictionOptions = MLPredictionOptions()) throws -> [LivenessOutput] {
        let batchIn = MLArrayBatchProvider(array: inputs)
        let batchOut = try model.predictions(from: batchIn, options: options)
        var results : [LivenessOutput] = []
        results.reserveCapacity(inputs.count)
        for i in 0..<batchOut.count {
            let outProvider = batchOut.features(at: i)
            let result =  LivenessOutput(features: outProvider)
            results.append(result)
        }
        return results
    }
}
