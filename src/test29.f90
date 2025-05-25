program test29

   use fortime, only: timer
   use forunittest, only: unit_test, rk

   implicit none

   type(timer) :: t
   type(unit_test) :: ut
   integer :: nl, nloops=3


   ! Elapsed time with nloops
   call t%dtimer_start()
   do nl = 1, nloops
      call sleep(1) ! Perform operations ntimes
   end do
   call t%dtimer_stop(nloops = nloops, message = 'Elapsed time:', print=.false.)
   call t%dtimer_write('test/test29_etimes.txt') ! Optionally, write the elapsed time to a file

   call ut%check(res=t%elapsed_dtime, expected=1.0_rk, tol=1.0e-1_rk, msg='test29')

end program test29

