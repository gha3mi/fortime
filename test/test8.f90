program test8

   use kinds
   use fortime
   use forunittest

   implicit none

   type(timer) :: t
   type(unit_test) :: ut
   integer :: nl, nloops=3


#if defined(USE_OMP)
   ! OMP time with nloops
   call t%otimer_start()
   do nl = 1, nloops
      call sleep(1) ! Perform operations ntimes
   end do
   call t%otimer_stop(nloops = nloops, message = 'OMP time:')
   call t%otimer_write('test/test8_otimes') ! Optionally, write the elapsed time to a file

   call ut%check(res=t%omp_time, expected=1.0_rk, tol=1.0e-1_rk, msg='test8')

#endif

end program test8

