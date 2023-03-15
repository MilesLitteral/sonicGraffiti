#include <iostream>
#include <fstream>
#include <string>
#include <vector>

// Function to split a file into JAB Codes
std::vector<std::string> splitIntoJABCodes(std::string filename) {
    std::ifstream input(filename, std::ios::binary);
    std::vector<std::string> jabCodes;
    int maxJabCodeSize = 9218;
    char buffer[maxJabCodeSize];
    while (input.read(buffer, maxJabCodeSize)) {
        std::string jabCode(buffer, buffer + input.gcount());
        jabCodes.push_back(jabCode);
    }
    if (input.gcount() > 0) {
        std::string jabCode(buffer, buffer + input.gcount());
        jabCodes.push_back(jabCode);
    }
    input.close();
    return jabCodes;
}

// Function to reassemble a file from JAB Codes
void reassembleFromJABCodes(std::vector<std::string> jabCodes, std::string filename) {
    std::ofstream output(filename, std::ios::binary);
    for (std::string jabCode : jabCodes) {
        output.write(jabCode.c_str(), jabCode.size());
    }
    output.close();
}

// Example usage
int main() {
    std::string inputFilename = "myFile.mp3";
    std::string outputFilename = "myFile_reassembled.mp3";
    std::vector<std::string> jabCodes = splitIntoJABCodes(inputFilename);
    reassembleFromJABCodes(jabCodes, outputFilename);
    return 0;
}


// import Data.ByteString (ByteString)
// import qualified Data.ByteString as BS
// import Data.List.Split (chunksOf)

// -- Function to split a file into JAB Codes
// splitIntoJABCodes :: FilePath -> IO [ByteString]
// splitIntoJABCodes filePath = do
//     fileContents <- BS.readFile filePath
//     let maxJABCodeSize = 9218
//         jabCodes = chunksOf maxJABCodeSize fileContents
//     return jabCodes

// -- Function to reassemble a file from JAB Codes
// reassembleFromJABCodes :: FilePath -> [ByteString] -> IO ()
// reassembleFromJABCodes filePath jabCodes = do
//     let fileContents = BS.concat jabCodes
//     BS.writeFile filePath fileContents

// -- Example usage
// main :: IO ()
// main = do
//     let inputFilePath = "myFile.mp3"
//         outputFilePath = "myFile_reassembled.mp3"
//     jabCodes <- splitIntoJABCodes inputFilePath
//     reassembleFromJABCodes outputFilePath jabCodes