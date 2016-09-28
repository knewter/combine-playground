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

        ( result, _ ) =
            parse RLEParser.rleToWorld gardenOfEden

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
