program test7

   use kinds
   use fortime
   use forunittest

   implicit none

   type(timer) :: t
   type(unit_test) :: ut


#if defined(USE_OMP)
   ! OMP time
   call t%otimer_start()
      call sleep(1) ! Perform operations here
   call t%otimer_stop()

   call ut%check(res=t%omp_time, expected=1.0_rk, tol=1.0e-3_rk, msg='test7')
#endif

end program test7

