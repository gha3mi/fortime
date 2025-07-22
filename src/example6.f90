program example6

   use fortime, only: timer

   implicit none

   type(timer) :: t
   integer :: nl, nloops=3

   call t%dtimer_start()
    do nl = 1, nloops
        call sleep(1) ! Perform operations ntimes
    end do
   call t%dtimer_stop(nloops = nloops, message = 'Elapsed time:', print = .true., color='red') ! nloops, message, print and color are optional.
   call t%dtimer_write('example/example6_etimes.txt') ! Optionally, write the elapsed time to a file

end program example6
