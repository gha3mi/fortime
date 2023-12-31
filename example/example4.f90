program example4

   use fortime

   implicit none

   type(timer) :: t
   integer :: nl, nloops=3

   call t%ctimer_start()
    do nl = 1, nloops
        call sleep(1) ! Perform operations ntimes
    end do
   call t%ctimer_stop(nloops = nloops, message = 'CPU time:', print = .true.) ! nloops, message and print are optional
   call t%ctimer_write('example/example4_ctimes') ! Optionally, write the elapsed time to a file

end program example4
