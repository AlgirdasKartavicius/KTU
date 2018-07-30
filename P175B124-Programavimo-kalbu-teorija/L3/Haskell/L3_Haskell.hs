{-
	Mangirdas Kazlauskas IFF-4/1
	L3, Haskell
	Užduotis: 1584 - Circular Sequence
-}
import System.IO
import Data.List

-- Add all possible circular sequence orders to list
testCaseToList :: String -> Int -> [String]
testCaseToList caseString counter = 
    if counter == 0
    then []
    else nextWord : (testCaseToList nextWord (counter - 1))
    where nextWord = ((tail caseString) ++ ((head caseString):[])) 

-- Find lexicographically smallest sequence
findSmallestSequence :: String -> String
findSmallestSequence word = head (sort (testCaseToList word (length word)))

-- Main recursive loop
findAllSmallestSequences :: [String] -> [String]
findAllSmallestSequences [] = []
findAllSmallestSequences (x:xs) = (findSmallestSequence x) : (findAllSmallestSequences xs)

-- Main program
main = do
    input <- readFile "data.txt"
    putStr (unlines(findAllSmallestSequences [x | x <- (tail (lines input))]))