module Tests exposing (..)

import Test exposing (..)
import Expect
import Combine.Num exposing (int)
import Combine exposing (parse, app)


all : Test
all =
    describe "A Test Suite"
        [ test "parsing integers" <|
            \() ->
                Expect.equal (parse int "123") ( Ok 123, { input = "", position = 3 } )
        , test "parsing integers using `app`" <|
            \() ->
                Expect.equal (app int { input = "123", position = 0 }) ( Ok 123, { input = "", position = 3 } )
        ]
