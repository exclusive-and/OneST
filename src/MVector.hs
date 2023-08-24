
module MVector where

import OneST
-- import OneST qualified as O

import Control.Monad.Primitive
import Data.Primitive.Array qualified as A


newArray
    :: PrimMonad m
    => Int
    -> a
    -> OneST Closed m (A.MutableArray (PrimState m) a)

newArray size x = Write (A.newArray size x)

readArray
    :: PrimMonad m
    => A.MutableArray (PrimState m) a
    -> Int
    -> OneST Open m a

readArray arr i = Read (A.readArray arr i)


writeArray
    :: PrimMonad m
    => A.MutableArray (PrimState m) a
    -> Int
    -> a
    -> OneST Closed m ()

writeArray arr i a = Write (A.writeArray arr i a)
