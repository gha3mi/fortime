program example4

   use fortime

   implicit none

   type(timer) :: t
   integer :: i, n=3

   call t%ctimer_start()
    do i = 1,n
        call sleep(1) ! Perform operations ntimes
    end do
   call t%ctimer_stop(nloops = n, message = 'CPU time:')
   call t%ctimer_write('example/example4_ctimes') ! Optionally, write the elapsed time to a file

end program example4
