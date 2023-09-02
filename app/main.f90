program main
  ! bot entrypoint
  use json_module, only: json_file
  use Utils, only: startsWith, replaceStr
  use Api, only: getUpdates, last_update_index
  use Commands
  implicit none

  ! read ENV variables
  character(len=120) :: VARIABLE
  character(len=:), allocatable :: TOKEN
  integer :: status
  
  ! getUpdates delay, seconds
  integer                   :: delay_updates = 1
  ! update_id
  character(:), allocatable :: update_id
  character(:), allocatable :: recived_update_id
  ! msg data
  ! result[1].message.from signature
  character(:), allocatable :: chat_id
  character(:), allocatable :: first_name
  character(:), allocatable :: username
  character(:), allocatable :: text
  ! update data index
  character(:), allocatable :: chat_id_str
  character(:), allocatable :: update_i
  ! response handle variables
  type(json_file)           :: json
  logical :: found

  ! get token from ENV
  call get_environment_variable("BOT_TOKEN", VARIABLE, status)
  TOKEN = trim(VARIABLE)
  if (status /= 0) then
    ! ok
    print*, "Get bot token from variable"
  else
    print*, "Error get variable. Please, add variable BOT_TOKEN=<TOKEN>"
    stop
  end if

  ! last update_id cache
  update_id = ""

  ! bot loop, handle updates, commands
  do
    json = getUpdates(TOKEN)
    ! get last update index item
    update_i = last_update_index(json)

    call json%get('result['//update_i//'].update_id', recived_update_id, found)
    ! detect update
    if (found .and. recived_update_id /= update_id) then
      ! first startup check, store update_id
      if (len(update_id) == 0) then
        update_id = recived_update_id
        cycle
      end if

      ! store update_id
      update_id = recived_update_id
      
      ! parse update event
      call json%get('result['//update_i//'].message.from.id', chat_id, found)
      call json%get('result['//update_i//'.message.from.first_name', first_name, found)
      call json%get('result['//update_i//'].message.from.username', username, found)
      call json%get('result['//update_i//'].message.text', text, found)
      print*, chat_id

      ! commands handle
      ! if command not founded - print help msg
      if (startsWith(text, "hello")) then
        json = greetings(TOKEN, chat_id)
      else if (startsWith(text, "!echo ")) then
        json = echo(TOKEN, chat_id, text)
      else if (text == "!cat") then
        json = send_cat(TOKEN, chat_id)
      else
        json = cmd_help(TOKEN, chat_id)
      end if
      ! end commands handle
    end if
    call sleep(delay_updates)
  end do
end program main
