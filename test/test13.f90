program test13

   use kinds
   use fortime
   use forunittest

   implicit none

   type(timer) :: t
   type(unit_test) :: ut


   ! Elapsed time
   call t%timer_start()
      call sleep(1) ! Perform operations here
   call t%timer_stop(print=.false.)

   call ut%check(res=t%elapsed_time, expected=1.0_rk, tol=1.0e-1_rk, msg='test13')

end program test13

