{-# LANGUAGE FlexibleInstances #-}

module SonicGraffiti (main) where

import Data.Binary
-- import System
-- import System.Subprocess

type MP3     = String
data JABCode = JABCode { byteData :: Int, metadata :: String } deriving (Show, Eq)

class ToJAB a where
    importJAB :: a -> Int

class FromJAB b where
    exportJAB :: b -> Int

instance ToJAB   MP3 where
    importJAB = undefined

instance FromJAB MP3 where
    exportJAB = undefined
    
instance Binary JABCode where
    get = undefined
    put = undefined

-- this will need a chs definition to tether the haskell code to the JABCode C/C++ executables
-- NOTE: You could also try to just bind the C Code (rather than refactored C++) in a chs
loadMP3  :: IO()
loadMP3  = undefined

writeMP3 :: IO()
writeMP3 = undefined --calls: mp3 to bytes, JABEncode, write to IO

-- .\jabcodeWriter --input 'Hello world' --output test.png
main :: IO()
main = print "Hello World!"
