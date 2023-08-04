module Main where

import Prelude

import Data.Array ((..))

import Data.Int (ceil, toNumber)
import Data.Number (sqrt)
import Effect (Effect)
import Effect.Console (log)


main :: Effect Unit
main = do
  log "🍝"

findAllFactorPairs ∷ Int → Array (Array Int)
findAllFactorPairs n = do
  i <- 1 .. ceil (sqrt (toNumber n))
  if n `mod` i == 0 then
    pure [i, n `div` i]
  else
    []