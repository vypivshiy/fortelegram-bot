module Utils
    implicit none
    private
    public :: loadToken, startsWith, replaceStr, int_to_str
    
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

    ! https://github.com/ecasglez/FortranUtilities/blob/master/src/Strings_M.F90#L527
    function startsWith(str, substr) RESULT(res)
        character(LEN=*), intent(in) :: str
        character(LEN=*), intent(in) :: substr
        logical                      :: res
        res = INDEX(str,substr) == 1
    end function startsWith

    ! https://stackoverflow.com/a/58980957
    pure recursive function replaceStr(string, search, substitute, count) result(modifiedString)
        implicit none
        character(len=*), intent(in)  :: string, search, substitute
        integer, optional, intent(in) :: count
        character(len=:), allocatable :: modifiedString
        integer :: i, stringLen, searchLen
        integer :: default_count

        if (present(count)) then
            default_count = count
        else
            default_count = -1
        end if

        stringLen = len(string)
        searchLen = len(search)
        if (stringLen==0 .or. searchLen==0) then
            modifiedString = ""
            return
        elseif (stringLen<searchLen) then
            modifiedString = string
            return
        end if
        i = 1
        do
            ! break cycle
            if (default_count /= -1 .and. i == default_count) then
                exit
            end if
            
            if (string(i:i+searchLen-1)==search) then
                modifiedString = string(1:i-1) // substitute // replaceStr(string(i+searchLen:stringLen),search,substitute)
                exit
            end if
            if (i+searchLen>stringLen) then
                modifiedString = string
                exit
            end if
            i = i + 1
            cycle
        end do
    end function replaceStr

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