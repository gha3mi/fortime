program test7

   use fortime, only: timer
   use forunittest, only: unit_test, rk

   implicit none

#if defined(USE_OMP)
   type(timer) :: t
   type(unit_test) :: ut


   ! OMP time
   call t%otimer_start()
      call sleep(1) ! Perform operations here
   call t%otimer_stop()

   call ut%check(res=t%omp_time, expected=1.0_rk, tol=1.0e-1_rk, msg='test7')
#endif

end program test7

