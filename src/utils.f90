module Utils
    implicit none
    private
    public :: loadToken, int_to_str
    
    contains
    function loadToken() result(token)
        !! load token from file `.token`
        character(:), allocatable :: token
        character(32)             :: filename = '.token'
        integer                   :: unit
        
        open(unit, file=filename, status='old', action='read')
        read(unit, '(A)') token
        close(unit) 
    end function

    ! https://github.com/rajkumardongre/github-org-analyzer/blob/master/src/utils.f90
    function int_to_str(int) result(str)
        integer, intent(in) :: int
        character(:), allocatable :: str
        integer :: j, temp, rem
        integer, allocatable :: nums(:)

        ! Initialize variables
        temp = int
        str = ''

        ! Convert the integer to its string representation
        do while (temp > 9)
            rem = mod(temp, 10)
            temp = temp / 10
            if (allocated(nums)) then
                nums = [rem, nums]
            else
                nums = [rem]
            end if
        end do

        ! Add the last digit to the string
        if (allocated(nums)) then
            nums = [temp, nums]
        else
            nums = [temp]
        end if

        ! Convert the individual digits to characters and concatenate them
        do j = 1, size(nums)
            str = str // achar(nums(j) + 48)
        end do

        ! Deallocate the temporary array
        deallocate(nums)
    end function int_to_str
end module