program test18

   use kinds
   use fortime

   implicit none

   type(timer) :: t
   integer :: nl, nloops=3


   ! CPU time with nloops
   call t%ctimer_start()
   do nl = 1, nloops
      call sleep(1) ! Perform operations ntimes
   end do
   call t%ctimer_stop(message = 'CPU time:', print=.false.)
   call t%ctimer_write('test/test18_ctimes.txt') ! Optionally, write the elapsed time to a file

end program test18

