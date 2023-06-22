program test1

    use :: fortime
    implicit none
    
    type(timer) :: t
    integer :: i, n=3
    

    call t%timer_start()

        do i = 1,n
            call sleep(2)
        end do
        
    call t%timer_stop(nloops = n, message = 'elapsed time:')
    call t%timer_write('elapsed_times_test1')
    
end program test1