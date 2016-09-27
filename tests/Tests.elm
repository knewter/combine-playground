module Tests exposing (..)

import Test exposing (..)
import Expect
import Combine.Num exposing (int)
import Combine.Num exposing (int)
import Combine exposing (parse, app, map, sequence, string, Parser)


all : Test
all =
    describe "A Test Suite"
        [ test "parsing integers" <|
            \() ->
                Expect.equal (parse int "123") ( Ok 123, { input = "", position = 3 } )
        , test "parsing integers using `app`" <|
            \() ->
                Expect.equal (app int { input = "123", position = 0 }) ( Ok 123, { input = "", position = 3 } )
        , test "mapping the result of parsing integers" <|
            \() ->
                Expect.equal (parse (map (\x -> x + 1) int) "123") ( Ok 124, { input = "", position = 3 } )
        , test "parsing exact sequences successfully" <|
            \() ->
                Expect.equal (parse pickJosh "Josh") ( Ok [ "J", "o", "s", "h" ], { input = "", position = 4 } )
        ]


pickJosh : Parser (List String)
pickJosh =
    sequence [ string "J", string "o", string "s", string "h" ]
