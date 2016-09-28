module RLEParser exposing (..)

import Combine.Num exposing (int)
import Combine exposing (parse, app, map, sequence, string, Parser, while, skip, sepBy, regex, andThen, choice, succeed, many, andMap)
import Combine.Char exposing (char)
import String


type alias World =
    List Bitmap



-- "bob$bob!"
-- rle "bob$bob!" => ["bob", "bob"]
-- parse a line and get the result
-- lin
-- sequence (List.map lineToBitmap ["bob", "bob")


listOfStringToWorld : List String -> World
listOfStringToWorld =
    let
        extractResult ( result, _ ) =
            Result.withDefault [] result
    in
        List.map (parse lineToBitmap >> extractResult)


rleToWorld : Parser World
rleToWorld =
    rle `andThen` (succeed << listOfStringToWorld)


lineToBitmap : Parser Bitmap
lineToBitmap =
    toStackCmds `andThen` (\x -> succeed <| toBitmap x)


consumeStack : StackContext -> List StackCmd
consumeStack stackContext =
    let
        ( _, remaining, acc ) =
            stackContext
    in
        case remaining of
            [] ->
                acc |> List.reverse

            _ ->
                consumeStack (consumeStackContext stackContext)


consumeStackContext : StackContext -> StackContext
consumeStackContext ( modifier, remaining, acc ) =
    case remaining of
        head :: rest ->
            case modifier of
                Nothing ->
                    case head of
                        Repeat x ->
                            ( Just (Repeat x), rest, acc )

                        _ ->
                            ( Nothing, rest, head :: acc )

                Just (Repeat n) ->
                    ( Nothing, rest, (List.repeat n head) ++ acc )

                _ ->
                    Debug.crash "WAT"

        [] ->
            ( modifier, [], acc )


type alias StackContext =
    ( Maybe StackCmd, List StackCmd, List StackCmd )


toStackContext : List StackCmd -> StackContext
toStackContext stackCmds =
    ( Nothing, stackCmds, [] )



-- [ Repeat 3, Dead, Alive ] -> [Dead, Dead, Dead, Alive]
--
-- -- context
-- (Nothing, [Repeat 3, Dead, Alive], [])
-- (Just Repeat 3, [Dead, Alive], [])
-- (Nothing, [Alive], [Dead, Dead, Dead])


toBitmap : List StackCmd -> List Bool
toBitmap stackCmds =
    toStackContext stackCmds
        |> consumeStack
        |> List.map ((==) Alive)


toStackCmds : Parser (List StackCmd)
toStackCmds =
    many toStackCmd


toStackCmd : Parser StackCmd
toStackCmd =
    choice [ repeat, dead, alive ]


repeat : Parser StackCmd
repeat =
    int |> map Repeat


dead : Parser StackCmd
dead =
    string "b" `andThen` (always (succeed Dead))


alive : Parser StackCmd
alive =
    string "o" `andThen` (always (succeed Alive))


type StackCmd
    = Repeat Int
    | Dead
    | Alive


unRle : String -> String
unRle rle =
    rle


type alias Bitmap =
    List Bool


type alias Line =
    String


rle : Parser (List Line)
rle =
    sepBy (string "$") (regex "[0123456789bo]+")
