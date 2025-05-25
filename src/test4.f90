program test4

   use fortime

   implicit none

   type(timer) :: t


   ! CPU time
   call t%ctimer_start()
      call sleep(1) ! Perform operations here
   call t%ctimer_stop()

end program test4

