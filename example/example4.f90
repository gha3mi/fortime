program example4

   use fortime, only: timer

   implicit none

   type(timer) :: t
   integer :: nl, nloops=3

   call t%ctimer_start()
    do nl = 1, nloops
        call sleep(1) ! Perform operations ntimes
    end do
   call t%ctimer_stop(nloops = nloops, message = 'CPU time:', print = .true., color='yellow') ! nloops, message, print and color are optional.
   call t%ctimer_write('example/example4_ctimes.txt') ! Optionally, write the elapsed time to a file

end program example4
