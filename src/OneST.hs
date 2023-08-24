
{-# LANGUAGE NoImplicitPrelude #-}

module OneST where

import Control.Applicative qualified as M
import Control.Monad qualified as M
import Control.Monad (Functor, Monad)


-- |
-- A variant of 'ST' with laws governing the order of operations on an
-- inner state monad.
--
-- 'OneST' has two modes:
--
--  ['Open']:   Operations on the inner state are permitted.
--
--  ['Closed']: Operations on the inner state are automatically blocked.
--
data OneST openness m a where
    Pure  ::   a -> OneST Open   m a
    Read  :: m a -> OneST Open   m a
    Write :: m a -> OneST Closed m a
    Join  :: m (OneST openness m a) -> OneST openness m a

-- |
-- The 'ST' is open to new operations.
--
data Open

-- |
-- Close an 'ST' to any new operations until the existing ones are committed.
--
data Closed


(>>=) :: Functor m => OneST Open m a -> (a -> OneST o m b) -> OneST o m b
Pure st >>= k = k st
Read st >>= k = Join (k M.<$> st)
Join st >>= k = Join ((>>= k) M.<$> st)

-- |
-- The killer: combine two non-contradictory operations in parallel.
--
-- We should be able to pair 'Closed' operations too, as long as they don't
-- conflict with each other.
--
-- fuse :: Functor m => OneST o m a -> OneST o m b -> OneST o m (a, b)

commit :: Monad m => OneST openness m a -> m a
commit (Pure  x ) = M.pure x
commit (Read  mo) = mo
commit (Write mo) = mo
commit (Join  mo) = mo M.>>= commit

