import Foundation
import UIKit
import Lottie

extension Bundle {
    static let diezResources = Bundle(url: Bundle.diez.resourceURL!.appendingPathComponent("Static.bundle"))
}

@objc(DEZFile)
public final class File: NSObject, Decodable {
    @objc public internal(set) var src: String
    @objc public internal(set) var type: String

    private enum CodingKeys: String, CodingKey {
        case src
        case type
    }

    init(
        src: String,
        type: String
    ) {
        self.src = src
        self.type = type
    }
}

extension File: Updatable {
    public func update(from decoder: Decoder) throws {
        guard let container = try decoder.containerIfPresent(keyedBy: CodingKeys.self) else { return }
        try container.update(value: &src, forKey: .src)
        try container.update(value: &type, forKey: .type)
    }
}

extension File: ReflectedCustomStringConvertible {
    public override var description: String {
        return reflectedDescription
    }
}

extension File {
    /**
     - Tag: File.url

     The `URL` of the resource the file is referencing.

     When in [hot mode](x-source-tag://Diez), this will be a `URL` to resource on the Diez server.

     When not in [hot mode](x-source-tag://Diez), this will be a `URL` pointing to the resource on the
     filesystem (within the SDK's asset bundle).

     - Note: This `URL` will only be `nil` if there is an issue parsing the `URL` when in
       [hot mode](x-source-tag://Diez). This should never be `nil` when not in
       [hot mode](x-source-tag://Diez).
     */
    public var url: URL? {
        if environment.isHot {
            let relativeURLComponents = URLComponents(string: src)
            return relativeURLComponents?.url(relativeTo: environment.serverURL)
        }

        return Bundle.diezResources?.url(forFile: self)
    }

    /**
     A `URLRequest` to the provided file.

     Uses the [url](x-source-tag://File.url) to create the request.

     - See: [url](x-source-tag://File.url)
     */
    public var request: URLRequest? {
        guard let url = url else {
            return nil
        }

        return URLRequest(url: url)
    }
}

extension Bundle {
    func url(forFile file: File) -> URL? {
        return url(forResource: file.src.removingPercentEncoding, withExtension: nil)
    }
}

@objc(DEZImage)
public final class Image: NSObject, Decodable {
    @objc public internal(set) var file: File
    @objc public internal(set) var file2x: File
    @objc public internal(set) var file3x: File
    @objc public internal(set) var width: Int
    @objc public internal(set) var height: Int

    private enum CodingKeys: String, CodingKey {
        case file
        case file2x
        case file3x
        case width
        case height
    }

    init(
        file: File,
        file2x: File,
        file3x: File,
        width: Int,
        height: Int
    ) {
        self.file = file
        self.file2x = file2x
        self.file3x = file3x
        self.width = width
        self.height = height
    }
}

extension Image: Updatable {
    public func update(from decoder: Decoder) throws {
        guard let container = try decoder.containerIfPresent(keyedBy: CodingKeys.self) else { return }
        try container.update(updatable: &file, forKey: .file)
        try container.update(updatable: &file2x, forKey: .file2x)
        try container.update(updatable: &file3x, forKey: .file3x)
        try container.update(value: &width, forKey: .width)
        try container.update(value: &height, forKey: .height)
    }
}

extension Image: ReflectedCustomStringConvertible {
    public override var description: String {
        return reflectedDescription
    }
}

extension Image {
    /**
     An image of the appropriate scale if it exits.

     When in [hot mode](x-source-tag://Diez), calls [image(withScale:)](x-source-tag://Image.imageWithScale)
     with `UIScreen.main.scale`.

     When not in [hot mode](x-source-tag://Diez), uses `UIImage(named:bundle:compatibleWith:)`.
     */
    @objc public var image: UIImage? {
        if environment.isHot {
            guard let hotImage = image(withScale: UIScreen.main.scale) else {
                return image(withScale: 3)
            }

            return hotImage
        }

        guard let name = (file.src as NSString).deletingPathExtension.removingPercentEncoding else {
            return nil
        }

        return UIImage(named: name, in: Bundle.diezResources, compatibleWith: nil)
    }

    /**
     - Tag: Image.urlForScale

     Gets a `URL` to the provided `scale`.

     The returned `URL` will only be `nil` if:
       - The provided scale does not round to 1, 2, or 3
       - The `URL` for the image at the provided scale does not exist
       - Diez is in [hot mode](x-source-tag://Diez) and the `URL` failed to resolve

     - Parameter scale: The scale of the image to request which is rounded to the nearest `Int` value before resolving
       the `URL`. This typically corresponds to the `UIScreen.main.scale`.

     - Returns: The `URL` of the image at the provided scale, or nil.
     */
    private func url(forScale scale: CGFloat) -> URL? {
        switch round(scale) {
        case 1: return file.url
        case 2: return file2x.url
        case 3: return file3x.url
        default: return nil
        }
    }


    /**
     - Tag Image.imageWithScale

     Gets an appropriately scaled `UIImage` if it exists.

     - Note: This operation is performed synchronously using the [url(forScale:)](x-source-tag://Image.urlForScale) and
       will block the thread while the image is fetched. This should only be an issue in
       [hot mode](x-source-tag://Diez) when the image may not be resolved from the SDK's bundle.

     - See: [url(forScale:)](x-source-tag://Image.urlForScale)
     */
    private func image(withScale scale: CGFloat) -> UIImage? {
        guard
            let url = url(forScale: scale),
            let data = try? Data(contentsOf: url) else {
                return nil
        }

        return UIImage(data: data, scale: scale)
    }
}

@objc(DEZLottie)
public final class Lottie: NSObject, Decodable {
    @objc public internal(set) var file: File
    @objc public internal(set) var loop: Bool
    @objc public internal(set) var autoplay: Bool

    private enum CodingKeys: String, CodingKey {
        case file
        case loop
        case autoplay
    }

    init(
        file: File,
        loop: Bool,
        autoplay: Bool
    ) {
        self.file = file
        self.loop = loop
        self.autoplay = autoplay
    }
}

extension Lottie: Updatable {
    public func update(from decoder: Decoder) throws {
        guard let container = try decoder.containerIfPresent(keyedBy: CodingKeys.self) else { return }
        try container.update(updatable: &file, forKey: .file)
        try container.update(value: &loop, forKey: .loop)
        try container.update(value: &autoplay, forKey: .autoplay)
    }
}

extension Lottie: ReflectedCustomStringConvertible {
    public override var description: String {
        return reflectedDescription
    }
}

extension Lottie {
    /**
     - Tag: Lottie.url

     The `URL` of the resource, or `nil` if it could not be parsed.

     - See: [File.url](x-source-tag://File.url)
     */
    @objc public var url: URL? {
        return file.url
    }
}

/**
 An error that occurred when attempting to load a `Lottie` object in a `LOTAnimationView`.
 */
public enum LottieError: Error, CustomDebugStringConvertible {
    case invalidURL
    case requestFailed(Error?)
    case deserializationError(Data, Error)
    case invalidType(json: Any)

    public var debugDescription: String {
        switch self {
        case .invalidURL:
            return "Lottie URL is invalid."
        case .requestFailed(let error):
            return "Request failed: \(String(describing: error))"
        case .deserializationError(let data, let error):
            let dataAsString = String(data: data, encoding: String.Encoding.utf8)
            return "Lottie file failed to be deserialized: \(error)\n\(String(describing: dataAsString))"
        case .invalidType(let json):
            return "JSON was not in the correct format ([AnyHashable: Any]): \(json)"
        }
    }
}

extension LOTAnimationView {
    /**
     A closure to be called when loading a `Lottie` animation has completed.
     */
    public typealias LoadCompletion = (Result<Void, LottieError>) -> Void

    /**
     - Tag: LOTAnimationView.loadLottieSessionCompletion

     Loads the provided `Lottie` animation.

     - Parameters:
       - lottie: The `Lottie` animation to be loaded.
       - session: The `URLSession` to be used when fetching the resource.
       - completion: A closure to be called when the load operation has completed.

     - Returns: The `URLSessionDataTask` used to fetch the asset, or `nil` if the
       [Lottie.url](x-source-tag://Lottie.url) is `nil`.
     */
    @discardableResult
    public func load(_ lottie: Lottie, session: URLSession = .shared, completion: LoadCompletion? = nil) -> URLSessionDataTask? {
        // TODO: Add a parameter that allows a fade in animated and add a description of the parameter to doc comment.
        // TODO: Should this be synchronous when resource is local?
        guard let url = lottie.url else {
            completion?(.failure(.invalidURL))
            return nil
        }

        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            self?.loadWith(data: data, lottie: lottie, response: response, error: error, completion: completion)
        }

        task.resume()

        return task
    }

    private func loadWith(data: Data?, lottie: Lottie, response: URLResponse?, error: Error?, completion: LoadCompletion?) {
        guard let data = data else {
            DispatchQueue.main.async { completion?(.failure(.requestFailed(error))) }
            return
        }

        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)

            guard let json = jsonObject as? [AnyHashable: Any] else {
                DispatchQueue.main.async { completion?(.failure(.invalidType(json: jsonObject))) }
                return
            }

            DispatchQueue.main.async {
                // TODO: Use bundle for referenced assets?
                self.setAnimation(json: json)

                self.loopAnimation = lottie.loop

                guard lottie.autoplay else {
                    completion?(.success(()))
                    return
                }

                self.play { _ in
                    completion?(.success(()))
                }
            }
        } catch {
            DispatchQueue.main.async { completion?(.failure(.deserializationError(data, error)))}
        }
    }

    /**
     The Objective-C equivalent of load(:session:completion:).

     - See: [load(:session:completion:)](x-source-tag://LOTAnimationView.loadLottieSessionCompletion)
     */
    @available(swift, obsoleted: 0.0.1)
    @discardableResult
    @objc(dez_loadLottie:withSession:completion:)
    public func load(_ lottie: Lottie, session: URLSession = .shared, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) -> URLSessionDataTask? {
        return load(lottie, session: session) { result in
            switch result {
            case .success:
                completion?(true, nil)
            case .failure(let error):
                completion?(false, error as NSError)
            }
        }
    }
}

@objc(DEZFont)
public final class Font: NSObject, Decodable {
    @objc public internal(set) var file: File
    @objc public internal(set) var name: String

    private enum CodingKeys: String, CodingKey {
        case file
        case name
    }

    override init() {
        file = File(src: "assets/SomeFont.ttf", type: "font")
        name = "SomeFont"
    }

    init(
        file: File,
        name: String
    ) {
        self.file = file
        self.name = name
    }
}

extension Font: Updatable {
    public func update(from decoder: Decoder) throws {
        guard let container = try decoder.containerIfPresent(keyedBy: CodingKeys.self) else { return }
        try container.update(updatable: &file, forKey: .file)
        try container.update(value: &name, forKey: .name)
    }
}

extension Font: ReflectedCustomStringConvertible {
    public override var description: String {
        return reflectedDescription
    }
}

@objc(DEZColor)
public final class Color: NSObject, Decodable {
    @objc public internal(set) var h: CGFloat
    @objc public internal(set) var s: CGFloat
    @objc public internal(set) var l: CGFloat
    @objc public internal(set) var a: CGFloat

    private enum CodingKeys: String, CodingKey {
        case h
        case s
        case l
        case a
    }

    init(
        h: CGFloat,
        s: CGFloat,
        l: CGFloat,
        a: CGFloat
    ) {
        self.h = h
        self.s = s
        self.l = l
        self.a = a
    }
}

extension Color: Updatable {
    public func update(from decoder: Decoder) throws {
        guard let container = try decoder.containerIfPresent(keyedBy: CodingKeys.self) else { return }
        try container.update(value: &h, forKey: .h)
        try container.update(value: &s, forKey: .s)
        try container.update(value: &l, forKey: .l)
        try container.update(value: &a, forKey: .a)
    }
}

extension Color: ReflectedCustomStringConvertible {
    public override var description: String {
        return reflectedDescription
    }
}

extension Color {
    /**
     A `UIColor` representation of the color.
     */
    @objc public var color: UIColor {
        let brightness = l + s * min(l, 1 - l)
        let saturation = (brightness == 0) ? 0 : 2 - 2 * l / brightness
        return UIColor(hue: h, saturation: saturation, brightness: brightness, alpha: a)
    }
}

@objc(DEZTypograph)
public final class Typograph: NSObject, Decodable {
    @objc public internal(set) var font: Font
    @objc public internal(set) var fontSize: CGFloat
    @objc public internal(set) var color: Color

    private enum CodingKeys: String, CodingKey {
        case font
        case fontSize
        case color
    }

    init(
        font: Font,
        fontSize: CGFloat,
        color: Color
    ) {
        self.font = font
        self.fontSize = fontSize
        self.color = color
    }
}

extension Typograph: Updatable {
    public func update(from decoder: Decoder) throws {
        guard let container = try decoder.containerIfPresent(keyedBy: CodingKeys.self) else { return }
        try container.update(updatable: &font, forKey: .font)
        try container.update(value: &fontSize, forKey: .fontSize)
        try container.update(updatable: &color, forKey: .color)
    }
}

extension Typograph: ReflectedCustomStringConvertible {
    public override var description: String {
        return reflectedDescription
    }
}

private var registeredFonts: Set<String> = []

private func registerFont(_ font: Font) {
    if font.file.src == "" || registeredFonts.contains(font.file.src) {
        return
    }

    registeredFonts.insert(font.file.src)

    guard
        let url = font.file.url,
        let data = try? Data(contentsOf: url) as CFData,
        let dataProvider = CGDataProvider(data: data),
        let cgFont = CGFont(dataProvider) else {
            return
    }

    CTFontManagerRegisterGraphicsFont(cgFont, nil)
}

extension Typograph {
    /**
     The `UIFont` of the `Typograph`.

     - Note: If the font fails to load this will fallback to the `UIFont.systemFont(ofSize:)`.
     */
    @objc public var uiFont: UIFont {
        registerFont(font)
        guard let font = UIFont(name: font.name, size: fontSize) else {
            return UIFont.systemFont(ofSize: fontSize)
        }

        return font
    }
}

public extension UILabel {
    @objc(dez_applyTypograph:)
    func apply(_ typograph: Typograph) {
        font = typograph.uiFont
        textColor = typograph.color.color
    }
}

public extension UITextView {
    @objc(dez_applyTypograph:)
    func apply(_ typograph: Typograph) {
        font = typograph.uiFont
        textColor = typograph.color.color
    }
}

public extension UITextField {
    @objc(dez_applyTypograph:)
    func apply(_ typograph: Typograph) {
        font = typograph.uiFont
        textColor = typograph.color.color
    }
}

@objc(DEZBindings)
public final class Bindings: NSObject, StateBag {
    @objc public internal(set) var image: Image
    @objc public internal(set) var lottie: Lottie
    @objc public internal(set) var typograph: Typograph

    private enum CodingKeys: String, CodingKey {
        case image
        case lottie
        case typograph
    }

    public override init() {
        image = Image(file: File(src: "assets/image%20with%20spaces.jpg", type: "image"), file2x: File(src: "assets/image%20with%20spaces@2x.jpg", type: "image"), file3x: File(src: "assets/image%20with%20spaces@3x.jpg", type: "image"), width: 246, height: 246)
        lottie = Lottie(file: File(src: "assets/lottie.json", type: "raw"), loop: true, autoplay: true)
        typograph = Typograph(font: Font(file: File(src: "assets/SomeFont.ttf", type: "font"), name: "SomeFont"), fontSize: 50, color: Color(h: 0.16666666666666666, s: 1, l: 0.5, a: 1))
    }

    init(
        image: Image,
        lottie: Lottie,
        typograph: Typograph
    ) {
        self.image = image
        self.lottie = lottie
        self.typograph = typograph
    }

    public static let name = "Bindings"
}

extension Bindings: Updatable {
    public func update(from decoder: Decoder) throws {
        guard let container = try decoder.containerIfPresent(keyedBy: CodingKeys.self) else { return }
        try container.update(updatable: &image, forKey: .image)
        try container.update(updatable: &lottie, forKey: .lottie)
        try container.update(updatable: &typograph, forKey: .typograph)
    }
}

extension Bindings: ReflectedCustomStringConvertible {
    public override var description: String {
        return reflectedDescription
    }
}

/// This is only intended to be used by Objective-C consumers.
/// In Swift use Diez<Bindings>.
@available(swift, obsoleted: 0.0.1)
@objc(DEZDiezBindings)
public final class DiezBridgedBindings: NSObject {
    @objc public init(view: UIView) {
        diez = Diez(view: view)

        super.init()
    }

    /**
     Registers the provided block for updates to the Bindings.

     The provided closure is called synchronously when this function is called.

     If in [hot mode](x-source-tag://Diez), this closure will also be called whenever changes occur to the
     component.

     - Parameter subscriber: The block to be called when the component updates.
     */
    @objc public func attach(_ subscriber: @escaping (Bindings?, NSError?) -> Void) {
        diez.attach { result in
            switch result {
            case .success(let component):
                subscriber(component, nil)
            case .failure(let error):
                subscriber(nil, error.asNSError)
            }
        }
    }

    private let diez: Diez<Bindings>
}
