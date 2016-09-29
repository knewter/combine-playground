module Main exposing (..)

import Html.App as App
import Html exposing (Html, table, tr, td, text)
import Html.Attributes exposing (style)
import World exposing (Model)
import Array exposing (Array)
import Time exposing (Time)
import Combine.Num exposing (int)
import Combine exposing (parse, app, map, sequence, string, Parser, while, skip, sepBy, regex, andThen, choice, succeed, many, andMap)
import Combine.Char exposing (char)
import RLEParser exposing (..)


type Msg
    = Tick Time


main : Program Never
main =
    App.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick _ ->
            ( World.tick model
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    table [] <|
        List.map viewRow (Array.toList model)


viewRow : Array Bool -> Html Msg
viewRow row =
    tr [] <|
        List.map viewCell (Array.toList row)


viewCell : Bool -> Html Msg
viewCell cell =
    let
        color =
            case cell of
                True ->
                    "black"

                False ->
                    "#ccc"
    in
        td [ style [ ( "width", "10px" ), ( "height", "10px" ), ( "background-color", color ) ] ] []


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (Time.millisecond * 200) Tick


init : ( Model, Cmd Msg )
init =
    let
        glider =
            "bob$2bo$3o!"

        gardenOfEden =
            "b3o2b2o3b$b2obobob3o$b3o2b5o$obobobobobo$4obobobob$4b3o4b$bobobob4o$obobobobobo$5o2b3ob$3obobob2ob$3b2o2b3o!"

        frenchKiss =
            "o9b$3o7b$3bo6b$2bo2b2o3b$2bo4bo2b$3b2o2bo2b$6bo3b$7b3o$9bo!"

        gliderProducingSwitchEngine =
            "bo65b$bo65b$bo65b$5bo61b$b3o2bo60b$o4bo61b$o3bo62b$b3o63b$15b2o50b$13b2o2bo49b$obo10b2o3bo48b$obo10b2o52b$obo64b$obo17bo46b$b2o14bo49b3$22bo2bo41b$26bo40b$22bo10b2o32b$26bo6b2o32b$22b4o41b$21bo45b$22b2o43b$23bo43b3$41b2o24b$41b2o24b3$13b2o52b$13b2o52b5$36b2o29b$36b3o9b2o17b$37bo10bobo16b$49bo17b$33bo33b$27bo5bo33b$26bobo11b3o24b$26bo2bo9bob2o24b$16b2o9b2o10b2o26b$15bo2bo48b$15b2ob2o47b$18bobo46b$20b2o45b$17bo3bo45b$17bo2bo44b2o$18b3o44b2o3$54bo12b$53bobo11b$40bo12b2o12b$39bobo25b$39b2o!"

        aircraftCarrier =
            "2o2b$o2bo$2b2o!"

        airforce =
            "7bo6b$6bobo5b$7bo6b2$5b5o4b$4bo5bob2o$3bob2o3bob2o$3bobo2bobo3b$2obo3b2obo3b$2obo5bo4b$4b5o5b2$6bo7b$5bobo6b$6bo!"

        blinkerfuse_synth =
            "obo36b$2o37b$bo37b3$3ob3ob3ob3ob3ob3ob3ob3ob3ob3o3$bo37b$2o37b$obo!"

        ( result, _ ) =
            parse RLEParser.rleToWorld blinkerfuse_synth

        rleWorld =
            Result.withDefault [] result

        width =
            case List.head rleWorld of
                Nothing ->
                    10

                Just a ->
                    List.length a

        padding =
            60

        ourWorld =
            rleWorld
                |> List.map (\cells -> cells ++ (List.repeat padding False))
                |> flip List.append (List.repeat padding (List.repeat (padding + width) False))
                |> List.append (List.repeat 10 (List.repeat (padding + width) False))
                |> List.map Array.fromList
                |> Array.fromList
    in
        ( ourWorld
        , Cmd.none
        )
