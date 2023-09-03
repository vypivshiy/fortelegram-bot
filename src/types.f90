module types
! telegram types implementation
implicit none
private
public :: update_t, message_t

type :: message_t
    character(:), allocatable :: chat_id
    character(:), allocatable :: first_name
    character(:), allocatable :: username
    character(:), allocatable :: text
end type message_t

type :: update_t
    type(message_t):: message
    character(:), allocatable  :: update_id
end type update_t

end module