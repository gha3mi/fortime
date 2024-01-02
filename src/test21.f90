program test21

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
   call t%otimer_stop(message = 'OMP time:', print=.false.)
   call t%otimer_write('test/test21_otimes') ! Optionally, write the elapsed time to a file

   call ut%check(res=t%omp_time, expected=real(nloops,rk)*1.0_rk, tol=1.0e-3_rk, msg='test21')

#endif

end program test21

