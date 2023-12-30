program example2

   use fortime

   implicit none

   type(timer) :: t
   integer :: nl, nloops=3

   call t%timer_start()
    do nl = 1, nloops
        call sleep(1) ! Perform operations ntimes
    end do
   call t%timer_stop(nloops = n, message = 'Elapsed time:') ! nloops and message are optional. 
   call t%timer_write('example/example2_etimes') ! Optionally, write the elapsed time to a file

end program example2
