program test1

   use fortime

   implicit none

   type(timer) :: t
   integer :: i, n=3


   call t%timer_start()
   call sleep(1) ! Perform operations here
   call t%timer_stop()


   call t%timer_start()
   do i = 1,n
      call sleep(1) ! Perform operations ntimes
   end do
   call t%timer_stop(nloops = n, message = 'Elapsed time:')
   call t%timer_write('test/test1_etimes') ! Optionally, write the elapsed time to a file




   call t%ctimer_start()
   call sleep(1) ! Perform operations here
   call t%ctimer_stop()


   call t%ctimer_start()
   do i = 1,n
      call sleep(1) ! Perform operations ntimes
   end do
   call t%ctimer_stop(nloops = n, message = 'CPU time:')
   call t%ctimer_write('test/test1_ctimes') ! Optionally, write the elapsed time to a file




#if defined(USE_OMP)
   call t%otimer_start()
   call sleep(1) ! Perform operations here
   call t%otimer_stop()
#endif


#if defined(USE_OMP)
   call t%otimer_start()
   do i = 1,n
      call sleep(1) ! Perform operations ntimes
   end do
   call t%otimer_stop(nloops = n, message = 'OMP time:')
   call t%otimer_write('test/test1_otimes') ! Optionally, write the elapsed time to a file
#endif




#if defined(USE_OMP)
   call t%mtimer_start()
   call sleep(1) ! Perform operations here
   call t%mtimer_stop()
#endif


#if defined(USE_OMP)
   call t%mtimer_start()
   do i = 1,n
      call sleep(1) ! Perform operations ntimes
   end do
   call t%mtimer_stop(nloops = n, message = 'MPI time:')
   call t%mtimer_write('test/test1_mtimes') ! Optionally, write the elapsed time to a file
#endif

end program test1

