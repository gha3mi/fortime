program test1

   use fortime, only: timer
   use forunittest, only: unit_test, rk

   implicit none

   type(timer) :: t
   type(unit_test) :: ut


   ! Elapsed time
   call t%timer_start()
      call sleep(1) ! Perform operations here
   call t%timer_stop()

   call ut%check(res=t%elapsed_time, expected=1.0_rk, tol=1.0e-1_rk, msg='test1')

end program test1

