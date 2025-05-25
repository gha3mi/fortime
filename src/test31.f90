program test31

   use fortime, only: timer
   use forunittest, only: unit_test, rk

   implicit none

   type(timer) :: t
   type(unit_test) :: ut


   ! Elapsed time
   call t%timer_start()
      call sleep(1) ! Perform operations here
   call t%timer_pause()
      call sleep(1) ! Pause operations here
   call t%timer_resume()
      call sleep(1) ! Perform operations here
   call t%timer_stop()

   call ut%check(res=t%elapsed_time, expected=2.0_rk, tol=1.0e-1_rk, msg='test31')

end program test31

