{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances #-}

module API where
   
import Control.Monad 
import Data.Time (UTCTime)
import Servant
import Servant.API 
import Servant.Server
import Data.Aeson hiding (json)
import Data.Aeson.Types
import Data.Monoid ((<>))
import Data.Text (Text, pack, unpack, takeWhile)
import Text.Pretty.Simple (pPrint)
import GHC.Generics
import Control.Monad.IO.Class
import Database.PostgreSQL.Simple
import Network.Wai
import Network.Wai.Handler.Warp
import GHC.TypeLits
import Prelude hiding (takeWhile)

data Issue = Issue {
  author :: Text, -- The author of the issue
  title :: Text,  -- The title of the issue
  comments :: Int -- The number of comments on the issue
} deriving (Generic, Show)

instance ToJSON Issue
instance FromJSON Issue 

-- get all issues 
-- issues/  

-- get issues by label
-- issues/:label

-- Defining the API
type AllIssues     = "kanji" :> Get '[JSON] [Text]
type IssuesByLabel = "kanji" :> Capture "label" Text :> Get '[JSON] [Text]

type IssuesAPI = AllIssues :<|> IssuesByLabel 
    
issuesAPI :: Proxy IssuesAPI
issuesAPI = Proxy

-- Define handler functions
getAllIssues :: Handler [Text]
getAllKanji = liftIO $ fetchIssues

getIssuesByLabel :: Text -> Handler [Text]
getIssuesByLabel label = liftIO $ fetchIssuesByLabel

-- Handler functions define the server
issuesServer :: Server IssuesAPI
issuesServer = getAllIssues :<|> getIssuesByLabel

-- The API definition along with the server definition
-- defines the application
app :: Application
app = serve issuesAPI issuesServer

-- Run the application on port 8080
runServer :: IO ()
runServer = run 8080 app

-- Use ReaderT for db connection
connectDb :: IO Connection
connectDb = do
    secret <- readFile "secret.txt"
    conn <- connect defaultConnectInfo {
        connectHost = "kanjidb.postgres.database.azure.com",
        connectUser = "rashadg1030@kanjidb",
        connectPassword = secret,
        connectDatabase = "kanjidb"
    }
    return conn  

fetchLiteral :: IO [Text] 
fetchLiteral = do
    conn <- connectDb
    literals <- query_ conn "select literal from kanjiTbl"
    return $ join literals -- Must be double list because postgresql-simple can't infer the type or something

fetchDetail :: IO [Kanji]
fetchDetail = do
    conn <- connectDb
    details <- query_ conn "select literal, grade, strokes, jaon, jakun, def, nanori from kanjiTbl"
    return details