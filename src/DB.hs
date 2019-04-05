{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module DB where

import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToField
import Database.PostgreSQL.Simple.ToRow
import Data.Text
import GHC.Generics

data Issue = Issue {
  author :: Text, -- The author of the issue
  title :: Text,  -- The title of the issue
  comments :: Int -- The number of comments on the issue
} deriving (Generic, Show)

instance ToRow Issue

writeIssues :: IO ()
writeIssues = do
  secret <- readFile "secret.txt"

  conn <- connect defaultConnectInfo {
    connectHost = "myHost.com",
    connectUser = "rashadg1030",
    connectPassword = secret,
    connectDatabase = "issue-wantedDB"
  }

  issues <- fetchIssues -- Some arbitrary function that returns IO [Issue]
  result <- executeMany conn "insert into issueTbl (author, title, comments) values (?,?,?)" issues
  print result
