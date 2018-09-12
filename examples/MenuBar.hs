{-# LANGUAGE LambdaCase        #-}
{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module MenuBar where

import           Data.Text                     (Text)
import           GI.Gtk                        (Box (..), Label (..),
                                                MenuBar (..), MenuItem (..),
                                                Orientation (..))
import           GI.Gtk.Declarative
import           GI.Gtk.Declarative.App.Simple

data State = Message Text

data Event = Open | Save | Help

view' :: State -> Widget Event
view' (Message msg) =
  container Box [#orientation := OrientationVertical] $ do
    boxChild False False 0 $
      container MenuBar [] $ do
        subMenu "File" $ do
          menuItem MenuItem [on #activate Open] $ widget Label [#label := "Open"]
          menuItem MenuItem [on #activate Save] $ widget Label [#label := "Save"]
        menuItem MenuItem [on #activate Help] $ widget Label [#label := "Help"]
    boxChild True False 0 $
      widget Label [#label := msg]

update' :: State -> Event -> Transition State Event
update' _ = \case
  Open -> Transition (Message "Opening file...") (return Nothing)
  Save -> Transition (Message "Saving file...") (return Nothing)
  Help -> Transition (Message "There is no help.") (return Nothing)

main :: IO ()
main = run
  "MenuBar"
  (Just (640, 480))
  App
    { view         = view'
    , update       = update'
    , inputs       = []
    , initialState = Message "Click a button in the menu."
    }
