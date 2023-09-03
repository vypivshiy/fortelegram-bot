module Api
    ! minimal telegram API implementation
    use json_module, only: json_file

    use http, only : request, response_type, HTTP_POST, pair_type
    use Utils, only: int_to_str
    use types, only: update_t, message_t
    implicit none

    private
    public :: getUpdates, getMe, sendMessage, getLastUpdateT
    contains
    ! telegram API methods
    function getUpdates(token) result(json)
        character(:), allocatable, intent(in) :: token
        character(:), allocatable             :: api_url
        character(:), allocatable             :: payload
        type(json_file)                       :: json

        ! payload for POST request
        ! in this example allowed only message events update
        payload = '{"allowed_updates": ["message"]}'
        ! build API url
        api_url = "https://api.telegram.org/bot"//token//"/getUpdates"
        ! send request and return `json_file` variable
        json = request_POST(api_url, payload) 
        
    end function


    function getMe(token) result(json)
        !! FIXME: json%deserialize not work!
        !! https://github.com/jacobwilliams/json-fortran/issues/540
        character(:), allocatable, intent(in) :: token
        character(:), allocatable             :: api_url
        character(:), allocatable             :: payload
        type(json_file)                       :: json
        
        payload = "{}"

        api_url = "https://api.telegram.org/bot"//token//"/getMe"
        json = request_POST(api_url, payload)

    end function

    function sendMessage(token, chat_id, text) result(json)
        !! send message
        ! variables for request
        character(:), allocatable, intent(in) :: token
        character(:), allocatable             :: api_url
        character(:), allocatable             :: payload
        type(json_file)                       :: json
        ! msg text
        character(:), allocatable, intent(in) :: text
        ! userid/chat_id/username
        character(:), allocatable, intent(in) :: chat_id

        payload = '{"text":"'//text//'","chat_id":'//chat_id//'}'
        print*, payload
        api_url = "https://api.telegram.org/bot"//token//"/sendMessage"
        json = request_POST(api_url, payload)

    end function

    function request_POST(api_url, payload) result(json)
        !! base request function for telegram API
        ! api URL
        character(:), allocatable, intent(in) :: api_url
        ! POST payload
        ! POST payload
        character(:), allocatable, intent(in) :: payload
        ! http variables
        type(pair_type), allocatable          :: req_header(:)
        type(response_type)                   :: response
        type(json_file)                       :: json
        !! api errors checks
        character(:), allocatable             :: api_error_code
        logical                               :: found
        

        req_header = [pair_type('Content-Type', 'application/json')]
        response = request(api_url, method=HTTP_POST, data=payload, header=req_header)

        if(.not. response%ok) then
            print *,'ERR: ', response%err_msg, " [",response%status_code, "]"
        end if
        print*, response%content
        
        ! deserialize response 
        call json%initialize()
        call json%deserialize(response%content)

        ! check parse status
        if (json%failed()) then
            print*, "JSON DESERIALIZE FAIL", char(10)  ! \n delimeter
        else
            print*, "JSON DESERIALIZE OK", char(10)  ! \n delimeter
            ! check api error_code
            call json%get("error_code", api_error_code, found)

            if (found) then
                print *, "API return ", api_error_code, " exit"
                stop
            endif
        end if
    end function

    function last_update_index(json) result(index_str)
        !! method for getUpdates response. return last index
        ! response
        type(json_file)             :: json
        logical                     :: found
        
        ! last index variables
        character(:), allocatable   :: index_str
        character(:), allocatable   :: tmp
        integer                     :: i

        do i = 1, 101
            index_str = int_to_str(i)
            call json%get("result["//index_str//"].update_id", tmp, found)
            if (.not. found) then
                ! return last index
                index_str = int_to_str(i-1)
                exit
            end if
        end do
    end function

    function getLastUpdateT(json) result(update)
        ! get last update_t event type
        type(json_file)  :: json
        logical :: found
        type(update_t) :: update
        type(message_t) :: message

        character(:), allocatable :: i

        character(:), allocatable :: update_id
        character(:), allocatable :: chat_id
        character(:), allocatable :: first_name
        character(:), allocatable :: username
        character(:), allocatable :: text
        

        ! get last index (string)
        i = last_update_index(json)
        ! parse json
        call json%get('result['//i//'].update_id', update_id, found)
        call json%get('result['//i//'].message.from.id', chat_id, found)
        call json%get('result['//i//'.message.from.first_name', first_name, found)
        call json%get('result['//i//'].message.from.username', username, found)
        call json%get('result['//i//'].message.text', text, found)
        message = message_t(chat_id=chat_id, &
                            first_name=first_name, &
                            username=username, &
                            text=text)
        update = update_t(update_id=update_id, message=message)
    end function
    
end module Api