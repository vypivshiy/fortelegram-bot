program main
  ! bot entrypoint
  use json_module, only: json_file
  use Utils, only: loadToken, startsWith, replaceStr
  use Api, only: getUpdates, last_update_index
  use Commands, only: greetings, echo
  implicit none
  
  character(:), allocatable :: TOKEN
  character(:), allocatable :: resp_content
  ! getUpdates delay
  integer                   :: delay_updates = 1
  ! update_id
  character(:), allocatable :: update_id
  character(:), allocatable :: recived_update_id
  ! msg data
  ! result[1].message.from
  character(:), allocatable :: chat_id
  character(:), allocatable :: first_name
  character(:), allocatable :: username
  character(:), allocatable :: text
  character(:), allocatable :: chat_id_str
  character(:), allocatable :: update_i
  ! response handle variables
  type(json_file)           :: json
  logical :: found
  ! set update_id value
  update_id = ""

  print*, "read token file"
  ! read telegram bot token file
  TOKEN = loadToken()
  print*, "done"

  ! bot loop
  do
    json = getUpdates(TOKEN)
    update_i = last_update_index(json)

    call json%get('result['//update_i//'].update_id', recived_update_id, found)
    print*, "update_id ", update_id, " recived ", recived_update_id
    ! detect update
    if (found .and. recived_update_id /= update_id) then
      print*, 'changed update_id!'
      update_id = recived_update_id
      
      ! extract last update event
      call json%get('result['//update_i//'].message.from.id', chat_id, found)
      call json%get('result['//update_i//'.message.from.first_name', first_name, found)
      call json%get('result['//update_i//'].message.from.username', username, found)
      call json%get('result['//update_i//'].message.text', text, found)
      print*, chat_id

      ! commands handle
      if (text == "hello") then
        json = greetings(TOKEN, chat_id)
      else if (startsWith(text, "!echo ")) then
        json = echo(TOKEN, chat_id, text)
      end if

      ! end commands
    else
      print*, "no updates"
    end if
    call sleep(delay_updates)
  end do
end program main
