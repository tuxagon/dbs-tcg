module Lobby exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Encode as JE
import Phoenix.Channel
import Phoenix.Push
import Phoenix.Socket


type alias Model =
    { phxSocket : Phoenix.Socket.Socket Msg
    , rooms : List Room
    }


type alias Room =
    { name : String
    }


type Msg
    = JoinChannel
    | PhoenixMsg (Phoenix.Socket.Msg Msg)
    | ShowJoinedRooms (List Room)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


socketServer : String
socketServer =
    "ws://localhost:4000/socket/websocket"


initPhxSocket : Phoenix.Socket.Socket Msg
initPhxSocket =
    Phoenix.Socket.init socketServer
        |> Phoenix.Socket.withDebug



-- |> Phoenix.Socket.on "" "room:lobby" ReceiveRoom


initModel : Model
initModel =
    Model initPhxSocket []


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Phoenix.Socket.listen model.phxSocket PhoenixMsg


valueToMsg : JE.Value -> Msg
valueToMsg value =
    let
        _ =
            Debug.log "value" value
    in
        ShowJoinedRooms []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PhoenixMsg msg ->
            let
                ( phxSocket, phxCmd ) =
                    Phoenix.Socket.update msg model.phxSocket
            in
                ( { model | phxSocket = phxSocket }, Cmd.map PhoenixMsg phxCmd )

        JoinChannel ->
            let
                channel =
                    Phoenix.Channel.init "room:lobby"
                        |> Phoenix.Channel.onJoin valueToMsg

                ( phxSocket, phxCmd ) =
                    Phoenix.Socket.join channel model.phxSocket

                -- |> Phoenix.Channel.onClose (always (ShowJoinedRooms []))
            in
                ( { model | phxSocket = phxSocket }, Cmd.map PhoenixMsg phxCmd )

        ShowJoinedRooms rooms ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ h3 [] [ text "Games" ]
        , div
            []
            [ button [ onClick JoinChannel ] [ text "Join Channel" ] ]
        ]
