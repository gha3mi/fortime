program test11

   use fortime, only: timer
   use forunittest, only: unit_test, rk

   implicit none

#if defined(USE_MPI)
   type(timer) :: t
   type(unit_test) :: ut
   integer :: nl, nloops=3
   integer :: ierr


   ! MPI time with nloops
   call mpi_init(ierr)
   call t%mtimer_start()
   do nl = 1, nloops
      call sleep(1) ! Perform operations ntimes
   end do
   call t%mtimer_stop(nloops = nloops, message = 'MPI time:')
   call mpi_finalize(ierr)
   call t%mtimer_write('test/test11_mtimes.txt') ! Optionally, write the elapsed time to a file

   call ut%check(res=t%mpi_time, expected=1.0_rk, tol=1.0e-1_rk, msg='test11')

#endif

end program test11

