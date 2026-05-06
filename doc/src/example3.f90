program example3

   use fortime, only: timer

   implicit none

   type(timer) :: t

   call t%ctimer_start()
    call sleep(1) ! Perform operations here
   call t%ctimer_stop()

end program example3
