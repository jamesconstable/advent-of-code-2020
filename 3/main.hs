import Data.Array ((!), Array, array, bounds)
import System.Environment (getArgs)

{-
   Solver for Day 3 of the Advent of Code 2020
   Problem description here: https://adventofcode.com/2020/day/3

   Takes a command line argument indicating which part to solve (1 or 2), reads
   input from stdin, and prints solution to stdout.
-}

main :: IO ()
main = do
  part <- getArgs
  case part of
    ["1"]     -> solve [(3, 1)]
    ["2"]     -> solve [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]
    otherwise -> putStrLn "Valid options are 1 or 2"

solve :: [(Int, Int)] -> IO ()
solve slopes = do
  mapData <- prepareMap . lines <$> getContents
  putStrLn $ show $ product $ map (countCollisions mapData) slopes

prepareMap :: [[Char]] -> Array (Int, Int) Int
prepareMap ls = array ((0, 0), (length ls - 1, length (head ls) - 1)) $ do
  (i, r) <- zip [0..] ls
  (j, e) <- zip [0..] r
  return ((i, j), if e == '#' then 1 else 0)

countCollisions :: Array (Int, Int) Int -> (Int, Int) -> Int
countCollisions mapData (sx, sy) =
  let
    (_, (yMax, xMax)) = bounds mapData
    steps = (0, 0) : map (\(y, x) -> (y+sy, (x+sx) `mod` (xMax+1))) steps
  in sum $ map (mapData !) $ takeWhile ((<= yMax) . fst) steps
