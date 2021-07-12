{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE OverloadedStrings #-}

{-@ LIQUID "--no-pattern-inline" @-}

module Controllers.List where

import           Storm.Actions      -- LH: name resolution 
import           Storm.Frankie (requireAuthUser,  status200 )
import           Storm.SMTP        -- LH: name resolution bug 
import           Control
import           Model             -- LH: name resolution bug
import           Storm.JSON (respondJSON, decodeBody)
import           Storm.Filters
import           Storm.Time ()
import qualified Data.Text as T
import           Storm.Infrastructure
import           Util (tShow)
import           Types
import           Storm.Insert (insert)
import           Storm.Helpers

------------------------------------------------------------------------------
-- | template "ping-pong" respond
------------------------------------------------------------------------------
pong :: Controller ()
pong = respondJSON status200 ("pong" :: T.Text)

------------------------------------------------------------------------------
-- | Extract User Info List
------------------------------------------------------------------------------
{-@ list :: UserId -> TaggedT<{\_ -> False}, {\_ -> True}> _ _ _ @-}
list :: UserId -> Controller ()
list userId = do
  viewerId  <- project userId' =<< requireAuthUser
  follower  <- checkFollower viewerId userId
  let self   = viewerId == userId
  let chk
       | self      = trueF
       | follower  = (itemLevel' ==. "public") ||: (itemLevel' ==. "follower")
       | otherwise =  itemLevel' ==. "public"
  items     <- selectList (itemOwner' ==. userId &&: chk)
  itemDatas <- mapT (\i -> ItemData `fmap` project itemDescription' i
                                    <*>    project itemLevel' i)
                    items
  respondJSON status200 itemDatas

{-@ checkFollower :: viewerId:_ -> userId:_ ->
                     TaggedT<{\_ -> True}, {\_ -> True}> _ _ {b:Bool| b => follows viewerId userId } @-}

checkFollower :: UserId -> UserId -> Controller Bool
checkFollower viewerId userId = do
  flws <- selectList (followerSubscriber' ==. viewerId &&:
                      followerPublisher' ==. userId &&:
                      followerStatus' ==. "accepted")
  case flws of
    [] -> return False
    _  -> return True

------------------------------------------------------------------------------
-- | Add a new item for logged in user
------------------------------------------------------------------------------
{-@ add :: TaggedT<{\_ -> True}, {\_ -> True}> _ _ _ @-}
add :: Controller ()
add = do
  owner   <- requireAuthUser
  ownerId <- project userId' owner
  ownerEmail <- project userEmailAddress' owner
  items   <- decodeBody
  mapT (\ItemData {..} -> insert (mkItem ownerId itemDescription itemLevel)) items
  respondJSON status200 ("OK: added " <> tShow (length items) <> " items for " <> ownerEmail)
