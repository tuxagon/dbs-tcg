module Lobby exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Encode as JE
import Json.Decode as JD
import Json.Decode.Pipeline as JDP
import Phoenix.Channel
import Phoenix.Push
import Phoenix.Socket
import Time.DateTime as TDT


type alias Model =
    { phxSocket : Phoenix.Socket.Socket Msg
    , lobby : Lobby
    }


type alias Lobby =
    { rooms : List Room
    }


type alias Room =
    { name : String
    , id : Int
    , players : List Player
    }


type alias Player =
    String


type Msg
    = PhoenixMsg (Phoenix.Socket.Msg Msg)
    | ShowLobby Lobby


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


initLobby : Lobby
initLobby =
    Lobby []


initModel : Model
initModel =
    Model initPhxSocket initLobby


init : ( Model, Cmd Msg )
init =
    joinChannel initModel


joinChannel : Model -> ( Model, Cmd Msg )
joinChannel model =
    let
        channel =
            Phoenix.Channel.init "room:lobby"
                |> Phoenix.Channel.onJoin joinDecoder
                |> Phoenix.Channel.onClose (always <| ShowLobby initLobby)

        ( phxSocket, phxCmd ) =
            Phoenix.Socket.join channel model.phxSocket
    in
        ( { model | phxSocket = phxSocket }, Cmd.map PhoenixMsg phxCmd )


subscriptions : Model -> Sub Msg
subscriptions model =
    Phoenix.Socket.listen model.phxSocket PhoenixMsg


joinDecoder : JE.Value -> Msg
joinDecoder value =
    let
        lobby =
            case JD.decodeValue decodeLobby value of
                Ok lobby ->
                    lobby

                Err error ->
                    Lobby []
    in
        ShowLobby lobby


decodeLobby : JD.Decoder Lobby
decodeLobby =
    JDP.decode Lobby
        |> JDP.required "rooms" (JD.list decodeRoom)


decodeRoom : JD.Decoder Room
decodeRoom =
    JDP.decode Room
        |> JDP.required "name" JD.string
        |> JDP.required "id" JD.int
        |> JDP.required "players" (JD.list JD.string)



--|> JDP.required "created_at" datetimeDecoder


datetimeDecoder : JD.Decoder TDT.DateTime
datetimeDecoder =
    JD.string
        |> JD.andThen
            (\val ->
                case TDT.fromISO8601 val of
                    Ok dt ->
                        JD.succeed dt

                    Err err ->
                        JD.fail err
            )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PhoenixMsg msg ->
            let
                ( phxSocket, phxCmd ) =
                    Phoenix.Socket.update msg model.phxSocket
            in
                ( { model | phxSocket = phxSocket }, Cmd.map PhoenixMsg phxCmd )

        ShowLobby lobby ->
            ( { model | lobby = lobby }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ h3 [] [ text "Games" ]
        , div
            []
            [ viewLobby model.lobby
            ]
        ]


viewLobby : Lobby -> Html Msg
viewLobby lobby =
    div
        []
        (List.map viewRoom lobby.rooms)


viewRoom : Room -> Html Msg
viewRoom room =
    div
        [ style [ ( "", "" ) ] ]
        [ strong [] [ text room.name ] ]


viewPlayer : Player -> Html Msg
viewPlayer player =
    p [] [ text player ]
