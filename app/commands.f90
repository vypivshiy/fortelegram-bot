module Commands
    ! bot commands implementation
    use Api, only: sendMessage
    use Utils, only: replaceStr
    use json_module, only: json_file

    implicit none
    private
    public :: echo, greetings, cmd_help, send_cat

    contains

    function echo(token, chat_id, text) result(json)
        ! trims `!echo ` part, returns the rest
        character(:), allocatable, intent(in) :: token
        character(:), allocatable, intent(in) :: chat_id
        type(json_file)                       :: json
        
        character(:), allocatable, intent(in) :: text
        character(:), allocatable             :: echo_text

        echo_text = replaceStr(text, "!echo ", "")

        json = sendMessage(token, chat_id, echo_text)
    end function


    function greetings(token, chat_id) result(json)
        ! send `hi!` if type `hello`
        character(:), allocatable, intent(in) :: token
        character(:), allocatable, intent(in) :: chat_id
        type(json_file)                       :: json

        character(:), allocatable             :: msg

        msg = "hi!"
        json = sendMessage(token, chat_id, msg)
    end function

    function cmd_help(token, chat_id) result (json)
        ! show available commands
        character(:), allocatable, intent(in) :: token
        character(:), allocatable, intent(in) :: chat_id
        type(json_file)                       :: json

        character(:), allocatable             :: msg

        ! CHAR(10) - equivalent to `\n`
        msg = "help commads:"// CHAR(10) // "hello - hi!"// CHAR(10) // &
        "!echo <string> - duplicate string"// CHAR(10) //"!cat - send cat picture"
        json = sendMessage(token, chat_id, msg)
    end function

    function send_cat(token, chat_id) result (json)
        ! send cat picture
        character(:), allocatable, intent(in) :: token
        character(:), allocatable, intent(in) :: chat_id
        type(json_file)                       :: json

        character(:), allocatable             :: photo_url

        ! yes, this hardcoded url
        photo_url = "https://upload.wikimedia.org/wikipedia/commons/a/a5/Red_Kitten_01.jpg"
        json = sendMessage(token, chat_id, photo_url)
    end function

end module