{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Types where

import Data.Aeson
import Data.Text                      ( Text(..), strip)
import GHC.Generics
import Util (sStrip,  stripPrefix )

-------------------------------------------------------------------------------------- 
-- | Payload for user-id info --------------------------------------------------------
-------------------------------------------------------------------------------------- 
data UserNG = UserNG
  { userFirstName :: Text
  , userLastName  :: Text
  }
  deriving (Show, Generic)

instance ToJSON UserNG where
  toEncoding = genericToEncoding (stripPrefix "user")

-------------------------------------------------------------------------------------- 
-- | Command for creating a new user 
-------------------------------------------------------------------------------------- 
data CreateUser = CreateUser
  { crUserEmail    :: Text
  , crUserPassword :: Text
  , crUserFirst    :: Text
  , crUserLast     :: Text
  }
  deriving (Show, Generic)

mkCreateUser :: Text -> Text -> Text -> Text -> CreateUser
mkCreateUser email pass first last =
  CreateUser (strip email) pass (strip first) (strip last)

instance FromJSON CreateUser where
  parseJSON = genericParseJSON defaultOptions

-------------------------------------------------------------------------------------- 
-- | Payload for a login/sign-in request ---------------------------------------------
-------------------------------------------------------------------------------------- 

data AuthInfo = AuthInfo
  { authInfoEmailAddress :: Text
  , authInfoPassword     :: Text
  }
  deriving Generic

instance FromJSON AuthInfo where
  parseJSON = genericParseJSON (stripPrefix "authInfo")


-------------------------------------------------------------------------------------- 
-- | Command for creating a new Item 
-------------------------------------------------------------------------------------- 
data ItemData = ItemData
  { itemDescription :: Text
  , itemPrice       :: Int
  , itemLevel       :: String
  }
  deriving (Show, Generic)

mkItemData :: Text -> Int -> String -> ItemData
mkItemData descr price levl = ItemData (strip descr) price (sStrip levl)

instance FromJSON ItemData where
  parseJSON = genericParseJSON (stripPrefix "item")

instance ToJSON ItemData where
  toEncoding = genericToEncoding (stripPrefix "item")
