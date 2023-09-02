program main
  ! bot entrypoint
  use json_module, only: json_file
  use Utils, only: startsWith, replaceStr
  use Api, only: getUpdates, last_update_index
  use Commands
  implicit none
  
  character(:), allocatable :: TOKEN
  integer :: status
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
  ! sys argv
  integer :: num_args

  ! set update_id value
  update_id = ""

  ! read telegram bot token file
  num_args = command_argument_count()
  if (num_args == 0) then
    print*, "Usage: ftg-bot <bot_token>"
    stop
  else
    call get_command_argument(2, TOKEN)
    TOKEN = trim(TOKEN)
    print*, TOKEN
  end if
  ! bot loop
  do
    ! check updates
    json = getUpdates(TOKEN)
    update_i = last_update_index(json)

    call json%get('result['//update_i//'].update_id', recived_update_id, found)
    print*, "update_id ", update_id, " recived ", recived_update_id
    ! detect update
    if (found .and. recived_update_id /= update_id) then
      ! set last update id
      update_id = recived_update_id
      
      ! parse update event
      call json%get('result['//update_i//'].message.from.id', chat_id, found)
      call json%get('result['//update_i//'.message.from.first_name', first_name, found)
      call json%get('result['//update_i//'].message.from.username', username, found)
      call json%get('result['//update_i//'].message.text', text, found)
      print*, chat_id

      ! commands handle
      if (startsWith(text, "hello")) then
        json = greetings(TOKEN, chat_id)
      else if (startsWith(text, "!echo ")) then
        json = echo(TOKEN, chat_id, text)
      else if (text == "!cat") then
        json = send_cat(TOKEN, chat_id)
      else
        json = cmd_help(TOKEN, chat_id)
      end if

      ! end commands
    else
      print*, "no updates"
    end if
    call sleep(delay_updates)
  end do
end program main
