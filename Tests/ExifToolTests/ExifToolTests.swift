import XCTest
    @testable import ExifTool

    @available(macOS 11.00, *)
    final class ExifToolTests: XCTestCase {
        func testGoodImage() {
            var testFilePath: String
            if let filepath = Bundle.module.pathForImageResource("DSC04247.jpg") {
                testFilePath = filepath
            } else {
                testFilePath = "/Users/hlemai/Dev/next/common/ExifTool/Tests/ExifToolTests/Resources/DSC04247.jpg"
            }

            let url = URL(fileURLWithPath: testFilePath)
            let exifData = ExifTool.read(fromurl: url).getMetadata(lang: "en")
            XCTAssert(exifData["File Path"]==testFilePath)
            XCTAssert(exifData["File Type"]=="JPEG")
            XCTAssert(exifData.count == 280)
        }
        func testBadImage() {
            var testFilePath: String
            if let filepath = Bundle.module.pathForImageResource("fakeimage.txt.jpg") {
                testFilePath = filepath
            } else {
                testFilePath = "/Users/hlemai/Dev/next/common/ExifTool/Tests/ExifToolTests/Resources/fakeimage.txt.jpg"
            }
            let url = URL(fileURLWithPath: testFilePath)
            let exifData = ExifTool.read(fromurl: url).getMetadata(lang: "en")
            XCTAssert(exifData["File Path"]==testFilePath)
            XCTAssert(exifData["File Type"]=="TXT")
        }
        func testNoImage() {
            var testFilePath: String
            if let filepath = Bundle.module.pathForImageResource("fakeimage.arw") {
                testFilePath = filepath
            } else {
                testFilePath = "/Users/hlemai/Dev/next/common/ExifTool/Tests/ExifToolTests/Resources/fakeimage.arw"
            }
            let url = URL(fileURLWithPath: testFilePath)
            let exifData = ExifTool.read(fromurl: url).getMetadata(lang: "en")
            XCTAssert(exifData["File Path"]==testFilePath)
            XCTAssert(exifData["File Type"]==nil)
        }

        func testWithnoExifTool() {
            let backup = ExifTool.exifToolPath
            ExifTool.setExifTool("/path/to/fake")
            var testFilePath: String
            if let filepath = Bundle.module.pathForImageResource("DSC04247.jpg") {
                testFilePath = filepath
            } else {
                testFilePath = "/Users/clement/Development//ExifTool/Tests/ExifToolTests/Resources/DSC04247.jpg"
            }
            let url = URL(fileURLWithPath: testFilePath)
            let exifData = ExifTool.read(fromurl: url).getMetadata(lang: "en")
            ExifTool.setExifTool(backup)
            XCTAssert(exifData["File Path"]==testFilePath)
            XCTAssert(exifData["File Type"]==nil)
        }
        func testDirectory() {
            var testFilePath: String
            let filepath = Bundle.module.bundlePath
            testFilePath = filepath

            let url = URL(fileURLWithPath: testFilePath)
            let exifData = ExifTool.read(fromurl: url).getMetadata(lang: "en")
            XCTAssert(exifData["File Path"]==testFilePath)
            XCTAssert(exifData["File Type"]==nil)
        }
        func testRawAndfilteredMeta() {
            var testFilePath: String
            if let filepath = Bundle.module.pathForImageResource("_DSC5130.ARW") {
                testFilePath = filepath
            } else {
                testFilePath = "/Users/hlemai/Dev/next/common/ExifTool/Tests/ExifToolTests/Resources/_DSC5130.ARW"
            }

            let url = URL(fileURLWithPath: testFilePath)
            let exifData = ExifTool.read(
                fromurl: url,
                tags: ["SequenceLength", "FocusLocation", "DateTimeOriginal"]).getMetadata(lang: "en")
            XCTAssert(exifData["ISO"] == nil)
            XCTAssert(exifData["Date/Time Original"] ?? "" == "2020:11:22 12:27:24")
            XCTAssert( (exifData["Sequence Length"] ?? "").starts(with: "1 "))
            XCTAssert(exifData.count == 4)
        }

        func testUpdate() {
            var testFilePath: String
            if let filepath = Bundle.module.pathForImageResource("_DSC5130.ARW") {
                testFilePath = filepath
            } else {
                testFilePath = "/Users/hlemai/Dev/next/common/ExifTool/Tests/ExifToolTests/Resources/_DSC5130.ARW"
            }
            let url = URL(fileURLWithPath: testFilePath)
            let exiftool = ExifTool.read(fromurl: url, tags: ["ImageDescription"])
            exiftool.update(metadata: ["ImageDescription": "Description by HLE"])

            let exifData = ExifTool.read(fromurl: url, tags: ["ImageDescription"])
            XCTAssert(exifData["ImageDescription"] == "Description by HLE")

        }
    }
