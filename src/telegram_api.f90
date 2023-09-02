module Api
    use json_module, only: json_file

    use http, only : request, response_type, HTTP_POST, pair_type
    implicit none

    private
    public :: getUpdates, getMe
    contains

    function getUpdates(token) result(json)
        character(:), allocatable, intent(in) :: token
        character(:), allocatable :: api_url
        character(:), allocatable :: payload
        type(json_file) :: json

        ! in this example allowed only message types
        payload = '{"allowed_updates": ["message"], "timeout": 10}'

        api_url = "https://api.telegram.org/bot"//token//"/getUpdates"
        json = make_request(api_url, payload) 
        
    end function


    function getMe(token) result(json)
        character(:), allocatable, intent(in) :: token
        character(:), allocatable :: api_url
        character(:), allocatable :: payload
        type(json_file) :: json
        
        payload = "{}"

        api_url = "https://api.telegram.org/bot"//token//"/getMe"
        json = make_request(api_url, payload)

    end function


    function make_request(api_url, payload) result(json)
        ! api URL
        character(:), allocatable, intent(in) :: api_url
        ! POST payload data
        character(:), allocatable, intent(in) :: payload
        ! HEADERS
        type(pair_type), allocatable :: req_header(:)
        type(response_type) :: response
        ! respone
        type(json_file) :: json
        ! new


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
    
end module Api