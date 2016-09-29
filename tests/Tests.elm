module Tests exposing (..)

import Test exposing (..)
import Expect
import Combine.Num exposing (int)
import Combine exposing (parse, app, map, sequence, string, Parser, while, skip, sepBy, regex, andThen, choice, succeed, many, andMap)
import Combine.Char exposing (char)
import String
import RLEParser exposing (..)


all : Test
all =
    describe "A Test Suite"
        [ test "parsing integers" <|
            \() ->
                Expect.equal (parse int "123") ( Ok 123, { input = "", position = 3 } )
        , test "parsing integers using `app`" <|
            \() ->
                Expect.equal (app int { input = "123", position = 0 }) ( Ok 123, { input = "", position = 3 } )
        , test "parsing integers using `app` 2" <|
            \() ->
                Expect.equal (app int { input = "123fox", position = 0 }) ( Ok 123, { input = "fox", position = 3 } )
        , test "mapping the result of parsing integers" <|
            \() ->
                Expect.equal (parse (map (\x -> x + 1) int) "123") ( Ok 124, { input = "", position = 3 } )
        , test "parsing exact sequences successfully" <|
            \() ->
                Expect.equal (parse pickJosh "Josh") ( Ok [ "J", "o", "s", "h" ], { input = "", position = 4 } )
        , test "parsing exact sequences successfully and mapping them" <|
            \() ->
                Expect.equal (parse pickJoshString "Josh") ( Ok "Josh", { input = "", position = 4 } )
        , test "decoding a glider that is run length encoded" <|
            \() ->
                Expect.equal (parse rle gliderRLE) ( Ok [ "bob", "2bo", "3o" ], { input = "!", position = 10 } )
        , test "parsing an RLE string" <|
            \() ->
                Expect.equal (unRle "bob") "bob"
        , test "parse stack command for Alive" <|
            \() ->
                Expect.equal (parse toStackCmd "o") ( Ok Alive, { input = "", position = 1 } )
        , test "parse stack command for Dead" <|
            \() ->
                Expect.equal (parse toStackCmd "b") ( Ok Dead, { input = "", position = 1 } )
        , test "parse stack command for Repeat" <|
            \() ->
                Expect.equal (parse toStackCmd "3") ( Ok (Repeat 3), { input = "", position = 1 } )
        , test "parse stack commands no repeat" <|
            \() ->
                Expect.equal (parse toStackCmds "bo") ( Ok [ Dead, Alive ], { input = "", position = 2 } )
        , test "parse stack commands with repeat" <|
            \() ->
                Expect.equal (parse toStackCmds "b2o") ( Ok [ Dead, Repeat 2, Alive ], { input = "", position = 3 } )
        , test "converting a list of stack commands into a line with no repeats" <|
            \() ->
                Expect.equal (toBitmap [ Dead, Dead, Alive ]) [ False, False, True ]
        , test "converting a list of stack commands into a stack context" <|
            \() ->
                Expect.equal (toStackContext [ Dead ]) ( Nothing, [ Dead ], [] )
        , test "consuming a single round of stack context - no repeat" <|
            \() ->
                Expect.equal (consumeStackContext ( Nothing, [ Dead ], [] )) ( Nothing, [], [ Dead ] )
        , test "consuming a single round of stack context - with repeat" <|
            \() ->
                Expect.equal (consumeStackContext ( Just (Repeat 2), [ Dead ], [] )) ( Nothing, [], [ Dead, Dead ] )
        , test "consuming an entire stackContext" <|
            \() ->
                Expect.equal (consumeStack ( Nothing, [ Dead, Dead ], [] )) [ Dead, Dead ]
        , test "converting a list of stack commands into a line with repeats" <|
            \() ->
                Expect.equal (toBitmap [ Dead, Repeat 2, Alive ]) [ False, True, True ]
        , test "converting a line to a bitmap" <|
            \() ->
                Expect.equal (parse lineToBitmap "b2o") ( Ok [ False, True, True ], { input = "", position = 3 } )
        , test "convert a full rle to a world" <|
            \() ->
                Expect.equal (parse rleToWorld "bob$boo!") ( Ok [ [ False, True, False ], [ False, True, True ] ], { input = "!", position = 7 } )
        , test "parsing list of strings to world" <|
            \() ->
                Expect.equal (listOfStringToWorld [ "bob", "bob" ]) [ [ False, True, False ], [ False, True, False ] ]
        ]


gliderRLE : String
gliderRLE =
    "bob$2bo$3o!"


gliderRLEDecoded : List Line
gliderRLEDecoded =
    [ "bob", "2bo", "3o" ]


pickJosh : Parser (List String)
pickJosh =
    sequence [ string "J", string "o", string "s", string "h" ]


pickJoshString : Parser String
pickJoshString =
    (sequence [ string "J", string "o", string "s", string "h" ])
        |> map String.concat
