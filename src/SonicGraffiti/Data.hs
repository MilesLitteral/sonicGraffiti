module SonicGraffiti.Data (
    JABCode
    , JABMatrix
    , ToJAB(..)
    , FromJAB(..)
    , splitIntoJABCodes
    , reassembleFromJABCodes
) where

-- import MegaStore
import Data.Text       (Text, unpack)
import Data.List.Split (chunksOf)
import System.Process  (createProcess, proc, cwd, std_out, StdStream(CreatePipe))
import qualified Data.ByteString as BS

newtype JABCode   = JABCode   { byteData :: BS.ByteString } deriving (Show, Eq)
newtype JABMatrix = JABMatrix { jabCodes :: [JABCode]     } deriving (Show, Eq)

class ToJAB a where
    exportJAB       ::  a   -> String   -> IO ()
    exportJABMatrix :: [a]  -> [String] -> IO ()

class FromJAB b where
    importJAB       :: b -> IO ()
    importJABL      :: b -> JABCode
    importJABMatrix :: b -> JABMatrix

instance ToJAB   BS.ByteString where
    exportJAB input name = do
        (_, Just hout, _, _) <- createProcess (proc "jabcodeWriter.exe" ["--input", show input, "--output", name ++ ".png"]){ cwd = Just "./", std_out = CreatePipe }
        return () --calls: mp3 to bytes, JABEncode, write to IO writeMP3 input "output.png"
    exportJABMatrix inputs name = do
        mapM_ (\x -> createProcess (proc "jabcodeWriter.exe" ["--input", show x, "--output", name ++ ".png"]){ cwd = Just "./" }) inputs --calls: mp3 to bytes, JABEncode, write to IO writeMP3 input "output.png"

instance FromJAB Text where
    importJAB name = do
                        (_, Just hout, _, _) <- createProcess (proc "jabcodeReader.exe" ["--output", unpack name]){ cwd = Just "./", std_out = CreatePipe }
                        return ()
    importJABL filePath = do 
                            jab <- BS.readFile filePath
                            JABCode jab
    importJABMatrix filePath = JABMatrix (map importJABL $ listDirectory filePath)
        
-- Helper Function to split a (large) file into a series of JAB Codes
splitIntoJABCodes :: FilePath -> IO [ByteString]
splitIntoJABCodes filePath = do
    fileContents <- BS.readFile filePath
    let maxJABCodeSize = 9218
        jabCodes = chunksOf maxJABCodeSize fileContents
    return jabCodes

-- Helper Function to reassemble a (large) file from a series JAB Codes or a JABMatrix
reassembleFromJABCodes :: FilePath -> [ByteString] -> IO ()
reassembleFromJABCodes filePath jabCodes = do
    let fileContents = BS.concat jabCodes
    BS.writeFile filePath fileContents

--wrapAsMegaStore
