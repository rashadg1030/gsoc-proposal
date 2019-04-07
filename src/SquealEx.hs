{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE NoImplicitPrelude #-}
 
module SquealEx where
    
import Relude
import Control.Monad (void)
import Control.Monad.IO.Class (liftIO)
import Squeal.PostgreSQL
import Squeal.PostgreSQL.Render

