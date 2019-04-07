{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeOperators #-}
 
module SquealEx where

import Squeal.PostgreSQL

type Schema =
    '[ "repos" ::: 'Table (
        '[ "pk_repos" ::: 'PrimaryKey '["id"] ] :=>
        '[ "id"         :::   'Def :=> 'NotNull 'PGint4
         , "title"      ::: 'NoDef :=> 'NotNull 'PGtext
         , "stargazers" ::: 'NoDef :=> 'NotNull 'PGint4
         , "commits"    ::: 'NoDef :=> 'NotNull 'PGint4
         ])
    , "issues" ::: 'Table (
        '[ "pk_issues"  ::: 'PrimaryKey '["id"]
         , "fk_repo_id" ::: 'ForeignKey '["repo_id"] "repos" '["id"]
         ] :=>
        '[ "id"       :::   'Def :=> 'NotNull 'PGint4
         , "repo_id"  ::: 'NoDef :=> 'NotNull 'PGint4
         , "author"   ::: 'NoDef :=> 'NotNull 'PGtext
         , "title"    ::: 'NoDef :=> 'NotNull 'PGtext
         , "comments" ::: 'NoDef :=> 'NotNull 'PGint4
         ]) 
    ]

