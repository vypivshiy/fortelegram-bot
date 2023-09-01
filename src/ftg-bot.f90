module ftg_bot
  implicit none
  private

  public :: say_hello
contains
  subroutine say_hello
    print *, "Hello, ftg-bot!"
  end subroutine say_hello
end module ftg_bot
