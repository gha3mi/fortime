program test10

   use kinds
   use fortime
   use forunittest

   implicit none

#if defined(USE_MPI)
   type(timer) :: t
   type(unit_test) :: ut
   integer :: ierr


   ! MPI time
   call mpi_init(ierr)
   call t%mtimer_start()
      call sleep(1) ! Perform operations here
   call t%mtimer_stop()
   call mpi_finalize(ierr)

   call ut%check(res=t%mpi_time, expected=1.0_rk, tol=1.0e-1_rk, msg='test10')

#endif

end program test10

