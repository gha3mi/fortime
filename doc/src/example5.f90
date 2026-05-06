program example5

   use fortime, only: timer

   implicit none

   type(timer) :: t

   call t%dtimer_start()
    call sleep(1) ! Perform operations here
   call t%dtimer_stop()

end program example5
