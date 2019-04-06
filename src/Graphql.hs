{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Graphql where

import Relude
import GraphQL
import GraphQL.API (Object, Field, Argument, (:>), Union)
import GraphQL.Resolver (Handler, (:<>)(..), unionValue)

-- GraphQL schema for a GitHub repo
-- type Repo {
--   title: String!,
--   stargazers: Int!,
--   commits: Int!
-- }

-- Type definition of Repo schema
type Repo = Object "Repo" '[] 
  '[ Field "title" Text
   , Field "stargazers" Int32
   , Field "commits" Int32
   ]

