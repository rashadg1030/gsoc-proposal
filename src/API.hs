{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module API where
   
import Servant
import Servant.API 
import Servant.Server
import Network.Wai
import Network.Wai.Handler.Warp
import GHC.TypeLits
import GHC.Generics
import Data.Text
import Data.Aeson
import Control.Monad 
import Control.Monad.IO.Class

data Issue = Issue {
  author :: Text, -- The author of the issue
  title :: Text,  -- The title of the issue
  comments :: Int -- The number of comments on the issue
} deriving (Generic, Show)

instance ToJSON Issue 

-- get all issues 
-- issues/  

-- get issues by label
-- issues/:label

-- Defining the API
type AllIssues     = "issues" :> Get '[JSON] [Issue]
type IssuesByLabel = "issues" :> Capture "label" Text :> Get '[JSON] [Issue]

type IssuesAPI = AllIssues :<|> IssuesByLabel 
    
issuesAPI :: Proxy IssuesAPI
issuesAPI = Proxy

-- Define handler functions
getAllIssues :: Handler [Issue]
getAllIssues = liftIO $ fetchIssues

getIssuesByLabel :: Text -> Handler [Issue]
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

fetchIssuesByLabel :: IO [Issue]
fetchIssuesByLabel = undefined

fetchIssues :: IO [Issue]
fetchIssues = undefined