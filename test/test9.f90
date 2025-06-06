program test9

   use fortime, only: timer
   use forunittest, only: unit_test, rk

   implicit none

#if defined(USE_OMP)
   type(timer) :: t
   type(unit_test) :: ut
   integer :: nl, nloops=3


   ! OMP time with nloops
   call t%otimer_start()
   do nl = 1, nloops
      call sleep(1) ! Perform operations ntimes
   end do
   call t%otimer_stop(message = 'OMP time:')
   call t%otimer_write('test/test9_otimes') ! Optionally, write the elapsed time to a file

   call ut%check(res=t%omp_time, expected=real(nloops,rk)*1.0_rk, tol=1.0e-1_rk, msg='test9')

#endif

end program test9

