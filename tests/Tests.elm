module Tests exposing (..)

import Test exposing (..)
import Expect
import Combine.Num exposing (int)
import Combine exposing (parse)


all : Test
all =
    describe "A Test Suite"
        [ test "parsing integers" <|
            \() ->
                Expect.equal (parse int "123") ( Ok 123, { input = "", position = 3 } )
        ]
