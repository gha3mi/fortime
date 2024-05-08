program example2

   use fortime

   implicit none

   type(timer) :: t
   integer :: nl, nloops=3

   call t%timer_start()
    do nl = 1, nloops
        call sleep(1) ! Perform operations ntimes
    end do
   call t%timer_stop(nloops = nloops, message = 'Elapsed time:', print = .true., color='green') ! nloops, message, print and color are optional. 
   call t%timer_write('example/example2_etimes.txt') ! Optionally, write the elapsed time to a file

end program example2
