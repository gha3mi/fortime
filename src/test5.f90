program test5

   use fortime, only: timer

   implicit none

   type(timer) :: t
   integer :: nl, nloops=3


   ! CPU time with nloops
   call t%ctimer_start()
   do nl = 1, nloops
      call sleep(1) ! Perform operations ntimes
   end do
   call t%ctimer_stop(nloops = nloops, message = 'CPU time:')
   call t%ctimer_write('test/test5_ctimes.txt') ! Optionally, write the elapsed time to a file

end program test5

