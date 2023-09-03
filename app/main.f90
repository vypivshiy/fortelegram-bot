program main
  ! bot entrypoint
  use json_module, only: json_file
  use Utils, only: startsWith, replaceStr
  use Api, only: getUpdates, getMe, getLastUpdateT
  use types, only: update_t
  use Commands
  implicit none

  ! read ENV variables
  character(len=120) :: VARIABLE
  character(len=:), allocatable :: TOKEN
  integer :: status
  ! getUpdates delay, seconds
  integer                   :: delay_updates = 1
  ! storage last update_id
  character(:), allocatable :: update_id
  ! response handle variables
  type(json_file)           :: json
  logical :: found
  ! getUpdate derived type item
  type(update_t) :: update

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

  json = getUpdates(TOKEN)
  update = getLastUpdateT(json)
  ! first startup storage last update_id
  update_id = update%update_id
  ! bot loop: handle updates, commands
  do
    ! create last update_t type
    json = getUpdates(TOKEN)
    update = getLastUpdateT(json)
    ! detect update
    if (update%update_id /= update_id) then
      ! store last update_id
      update_id = update%update_id
      ! commands handle
      ! if command not founded - print help msg
      if (startsWith(update%message%text, "hello")) then
        json = greetings(TOKEN, update%message%chat_id)
      else if (startsWith(update%message%text, "!echo ")) then
        json = echo(TOKEN, update%message%chat_id, update%message%text)
      else if (update%message%text == "!cat") then
        json = send_cat(TOKEN, update%message%chat_id)
      else
        json = cmd_help(TOKEN, update%message%chat_id)
      end if
      ! end commands handle
    end if
    call sleep(delay_updates)
  end do
end program