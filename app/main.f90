program main
  use json_module, only: json_file
  use Utils, only: loadToken
  use Api, only: getUpdates
  implicit none
  
  character(:), allocatable :: TOKEN
  character(:), allocatable :: resp_content
  integer                   :: delay_updates = 30
  ! json
  type(json_file)           :: json
  logical :: found
  character(:), allocatable :: print_buffer
  integer :: update_id

  TOKEN = loadToken()
  
  do
    json = getUpdates(TOKEN)
    call json%print()
    call json%get('result[1].update_id', update_id, found); if(found) print*, " ", update_id
    call sleep(delay_updates)
  end do 

end program main
