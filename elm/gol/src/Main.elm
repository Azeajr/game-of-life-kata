module Main exposing (..)

import Array exposing (Array)
import Browser
import Html exposing (Html, div)
import Random
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time


type alias Board =
    Array (Array Bool)


squareSize : Int
squareSize =
    100


createEmptyBoard : Int -> Int -> Board
createEmptyBoard width height =
    Array.repeat width (Array.repeat height False)


addCell : Int -> Int -> Board -> Board
addCell x y board =
    board
        |> Array.set x
            (board
                |> Array.get x
                |> Maybe.map
                    (\row ->
                        row
                            |> Array.set y True
                    )
                |> Maybe.withDefault
                    (Array.repeat (Array.length board) False)
            )


getNeighbours : Coord -> Board -> List Coord
getNeighbours coord board =
    let
        x =
            coord.x

        y =
            coord.y

        width =
            Array.length board

        height =
            Array.length (Maybe.withDefault Array.empty (Array.get 0 board))
    in
    [ { x = x - 1, y = y - 1 }
    , { x = x - 1, y = y }
    , { x = x - 1, y = y + 1 }
    , { x = x, y = y - 1 }
    , { x = x, y = y + 1 }
    , { x = x + 1, y = y - 1 }
    , { x = x + 1, y = y }
    , { x = x + 1, y = y + 1 }
    ]
        |> List.filter
            (\cord ->
                cord.x
                    >= 0
                    && cord.x
                    < width
                    && cord.y
                    >= 0
                    && cord.y
                    < height
            )
        |> List.filter
            (\cord ->
                board
                    |> Array.get cord.x
                    |> Maybe.map
                        (\row ->
                            row
                                |> Array.get cord.y
                                |> Maybe.withDefault False
                        )
                    |> Maybe.withDefault False
            )


nextBoard : Board -> Board
nextBoard board =
    board
        |> Array.indexedMap
            (\x_val row ->
                row
                    |> Array.indexedMap
                        (\y_val cell ->
                            let
                                neighbours =
                                    getNeighbours { x = x_val, y = y_val } board
                            in
                            if cell then
                                if List.length neighbours < 2 then
                                    False

                                else if List.length neighbours > 3 then
                                    False

                                else
                                    True

                            else if List.length neighbours == 3 then
                                True

                            else
                                False
                        )
            )


validateCoord3by3 : Coord -> Board -> Bool
validateCoord3by3 center board =
    if center.x - 1 >= 0 && center.x + 1 <= Array.length board && center.y - 1 >= 0 && center.y + 1 <= Array.length (Maybe.withDefault Array.empty (Array.get 0 board)) then
        True

    else
        False


addTub : Coord -> Board -> Board
addTub center board =
    if validateCoord3by3 center board then
        board
            |> addCell (center.x - 1) center.y
            |> addCell (center.x + 1) center.y
            |> addCell center.x (center.y - 1)
            |> addCell center.x (center.y + 1)

    else
        board


addGlider : Coord -> Board -> Board
addGlider center board =
    if validateCoord3by3 center board then
        board
            |> addCell (center.x + 1) (center.y - 1)
            |> addCell (center.x - 1) center.y
            |> addCell (center.x + 1) center.y
            |> addCell center.x (center.y + 1)
            |> addCell (center.x + 1) (center.y + 1)

    else
        board


type alias Coord =
    { x : Int
    , y : Int
    }


randomCoord : Int -> Int -> Random.Generator Coord
randomCoord width height =
    Random.pair (Random.int 0 width) (Random.int 0 height)
        |> Random.map (\( x, y ) -> { x = x, y = y })



-- type Msg
--     = NewRandomCoord Coord
--     | GenerateRandomCoord
-- generateRandomCoords : Int -> Int -> Cmd Msg
-- generateRandomCoords width height =
--     Random.generate NewRandomCoord (randomCoord width height)


renderBoard : Array (Array Bool) -> Html msg
renderBoard board =
    board
        |> Array.indexedMap
            (\x_val row ->
                row
                    |> Array.indexedMap
                        (\y_val cell ->
                            if cell then
                                rect
                                    [ x (String.fromInt (x_val * squareSize))
                                    , y (String.fromInt (y_val * squareSize))
                                    , width (String.fromInt squareSize)
                                    , height (String.fromInt squareSize)
                                    , fill "red"
                                    ]
                                    []

                            else
                                rect
                                    [ x (String.fromInt (x_val * squareSize))
                                    , y (String.fromInt (y_val * squareSize))
                                    , width (String.fromInt squareSize)
                                    , height (String.fromInt squareSize)
                                    , fill "green"
                                    ]
                                    []
                        )
            )
        |> Array.map Array.toList
        |> Array.toList
        |> List.concat
        |> svg
            [ viewBox
                (String.join " "
                    [ "0"
                    , "0"
                    , String.fromInt (Array.length board * squareSize)
                    , String.fromInt (Array.length (Maybe.withDefault Array.empty (Array.get 0 board)) * squareSize)
                    ]
                )
            , width "1000"
            , height "1000"
            ]


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    Board


init : () -> ( Model, Cmd Msg )
init =
    \_ ->
        ( createEmptyBoard 10 10
            |> addTub { x = 5, y = 5 }
            |> addGlider { x = 1, y = 1 }
        , Cmd.none
        )



-- Update


type Msg
    = NextBoard


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NextBoard ->
            ( nextBoard model, Cmd.none )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions _ =
    Time.every 1000 (\_ -> NextBoard)



-- View


view : Model -> Html Msg
view model =
    div [] [ renderBoard model ]
