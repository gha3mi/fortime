program example1

    use :: fortime
    implicit none
    
    type(timer) :: t
    integer :: i, n=3
    

    call t%timer_start()

        do i = 1,n
            call sleep(1)
        end do
        
    call t%timer_stop(nloops = n, message = 'elapsed time:')
    call t%timer_write('example/example1_elapsed_times')
    
end program example1