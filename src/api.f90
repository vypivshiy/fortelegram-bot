module Api
    use json_module, only: json_file

    use http, only : request, response_type, HTTP_POST, pair_type
    use Utils, only: int_to_str
    implicit none

    private
    public :: getUpdates, getMe, sendAudio, sendMessage, sendPhoto, last_update_index
    contains
    ! telegram API methods
    function getUpdates(token) result(json)
        character(:), allocatable, intent(in) :: token
        character(:), allocatable             :: api_url
        character(:), allocatable             :: payload
        type(json_file)                       :: json

        ! in this example allowed only message events update
        ! the limit is set to 1 to avoid writing event processing logic
        payload = '{"allowed_updates": ["message"]}'

        api_url = "https://api.telegram.org/bot"//token//"/getUpdates"
        json = request_POST(api_url, payload) 
        
    end function


    function getMe(token) result(json)
        !! FIXME: json%deserialize not work!
        character(:), allocatable, intent(in) :: token
        character(:), allocatable             :: api_url
        character(:), allocatable             :: payload
        type(json_file)                       :: json
        
        payload = "{}"

        api_url = "https://api.telegram.org/bot"//token//"/getMe"
        json = request_POST(api_url, payload)

    end function

    function sendMessage(token, chat_id, text) result(json)
        character(:), allocatable, intent(in) :: token
        character(:), allocatable, intent(in) :: text
        character(:), allocatable, intent(in) :: chat_id
        character(:), allocatable             :: api_url
        character(:), allocatable             :: payload
        type(json_file)                       :: json

        payload = '{"text":"'//text//'","chat_id":'//chat_id//'}'
        print*, payload
        api_url = "https://api.telegram.org/bot"//token//"/sendMessage"
        json = request_POST(api_url, payload)

    end function

    function sendPhoto(token, chat_id, filename) result(json)
        ! send photo
        character(:), allocatable, intent(in) :: token
        character(:), allocatable, intent(in) :: filename
        character(:), allocatable, intent(in) :: chat_id
        character(:), allocatable             :: api_url
        character(:), allocatable             :: payload
        type(json_file)                       :: json

        api_url = "https://api.telegram.org/bot"//token//"/sendPhoto"
        payload = '{"chat_id":'//chat_id//'}'
        json = request_Multipart(api_url, filename, payload)

    end function

    function sendAudio(token, chat_id, filename) result(json)
        ! send audio
        character(:), allocatable, intent(in) :: token
        character(:), allocatable, intent(in) :: filename
        character(:), allocatable, intent(in) :: chat_id
        character(:), allocatable             :: api_url
        character(:), allocatable             :: payload
        type(json_file)                       :: json

        api_url = "https://api.telegram.org/bot"//token//"/sendAudio"
        payload = '{"chat_id":'//chat_id//'}'
        json = request_Multipart(api_url, filename, payload)

    end function
    ! end telegram API methods

    function request_POST(api_url, payload) result(json)
        ! base request function
        ! api URL
        character(:), allocatable, intent(in) :: api_url
        ! POST payload data
        character(:), allocatable, intent(in) :: payload
        ! HEADERS
        type(pair_type), allocatable :: req_header(:)
        ! response 
        type(response_type) :: response
        type(json_file) :: json

        req_header = [pair_type('Content-Type', 'application/json')]
        response = request(api_url, method=HTTP_POST, data=payload, header=req_header)

        if(.not. response%ok) then
            print *,'ERR: ', response%err_msg, " [",response%status_code, "]"
        end if
        print*, response%content
        
        call json%initialize()
        call json%deserialize(response%content)
        ! debug json read status
        if (json%failed()) then
            print*, "JSON DESERIALIZE FAIL"
        else
            print*, "JSON DESERIALIZE OK"
        end if
        print*, ""
    end function

    function request_Multipart(api_url, filename, payload) result(json)
        ! api URL
        character(:), allocatable, intent(in) :: api_url
        ! POST payload data
        character(:), allocatable, intent(in) :: payload
        character(:), allocatable, intent(in) :: filename
        ! HEADERS
        type(pair_type), allocatable :: file_data(:)
        type(pair_type), allocatable :: form_data(:)
        ! respone
        type(response_type) :: response
        type(json_file) :: json
        
        file_data = [pair_type(filename, filename), pair_type('data', payload)]
        response = request(api_url, method=HTTP_POST, form=file_data)

        if(.not. response%ok) then
            print *,'ERR: ', response%err_msg, " [",response%status_code, "]"
        end if
        print*, response%content
        
        call json%initialize()
        call json%deserialize(response%content)
        ! debug print
        if (json%failed()) then
            print*, "JSON DESERIALIZE FAIL"
        else
            print*, "JSON DESERIALIZE OK"
        end if
        print*, ""
    end function

    function last_update_index(json) result(index_str)
        type(json_file) :: json

        character(:), allocatable   :: index_str
        character(:), allocatable   :: tmp
        integer                     :: i
        logical                     :: found
        index_str = "0"
        do i = 1, 101
            index_str = int_to_str(i)
            call json%get("result["//index_str//"].update_id", tmp, found)
            if (.not. found) then
                index_str = int_to_str(i-1)
                exit
            end if
        end do
    end function
    
end module Api