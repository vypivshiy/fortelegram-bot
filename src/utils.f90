module Utils
    implicit none
    private
    public :: loadToken
    
    contains
    function loadToken() result(token)
        !! load token from file `.token`
        character(12) :: filename = '.token'
        character(:), allocatable :: token
        integer      :: unit
        
        open(unit, file=filename, status='old', action='read')
        read(unit, '(A)') token
        close(unit) 
    end function

end module