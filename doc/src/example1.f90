program example1

   use fortime, only: timer

   implicit none

   type(timer) :: t

   call t%timer_start()
    call sleep(1) ! Perform operations here
   call t%timer_stop()

end program example1
