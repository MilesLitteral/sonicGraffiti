module SonicGraffiti.Main (sonicMain, main) where

import SonicGraffiti.Data

-- -- Example usage
sonicMain :: IO ()
sonicMain = do
    let inputFilePath = "myFile.mp3"
        outputFilePath = "myFile_reassembled.mp3"
    jabCodes <- splitIntoJABCodes inputFilePath
    exportJABMatrix jabCodes $ map [0..] "myFile"

    reassembleFromJABCodes outputFilePath jabCodes


main :: IO ()
main = do
    print "1. Import JAB"
    print "2. Export JAB"
    print "3. Create JABMatrix"
    i <- getLine
    case i of
        "1" -> do
                input <- getLine
                name  <- getLine
                exportJAB input name
        "2" -> do
                name  <- getLine
                importJAB name
        "3" -> do
                name  <- getLine
                mapM_ print name
                exportJAB input name
        _   -> print "invalid input"