program test3

   use kinds
   use fortime
   use forunittest

   implicit none

   type(timer) :: t
   type(unit_test) :: ut
   integer :: nl, nloops=3


   ! Elapsed time with nloops
   call t%timer_start()
   do nl = 1, nloops
      call sleep(1) ! Perform operations ntimes
   end do
   call t%timer_stop(message = 'Elapsed time:')
   call t%timer_write('test/test3_etimes') ! Optionally, write the elapsed time to a file

   call ut%check(res=t%elapsed_time, expected=real(nloops,rk)*1.0_rk, tol=1.0e-1_rk, msg='test3')

end program test3

