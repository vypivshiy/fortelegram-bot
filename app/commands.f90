module Commands
    ! bot commands implementation
    use Api, only: sendMessage
    use Utils, only: replaceStr
    use json_module, only: json_file

    implicit none
    private
    public :: echo, greetings

    contains

    function echo(token, chat_id, text) result(json)
        character(:), allocatable, intent(in) :: token
        character(:), allocatable, intent(in) :: chat_id
        character(:), allocatable, intent(in) :: text
            
        type(json_file) :: json

        character(:), allocatable             :: echo_text

        echo_text = replaceStr(text, "!echo ", "")

        json = sendMessage(token, chat_id, echo_text)
    end function


    function greetings(token, chat_id) result(json)
        character(:), allocatable, intent(in) :: token
        character(:), allocatable, intent(in) :: chat_id
        character(:), allocatable             :: msg

        type(json_file) :: json

        msg = "hi!"
        json = sendMessage(token, chat_id, msg)
    end function
end module