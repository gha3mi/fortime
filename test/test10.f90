program test10

   use kinds
   use fortime
   use forunittest

   implicit none

   type(timer) :: t
   type(unit_test) :: ut
   integer :: ierr


#if defined(USE_MPI)
   ! MPI time
   call mpi_init(ierr)
   call t%mtimer_start()
      call sleep(1) ! Perform operations here
   call t%mtimer_stop()
   call mpi_finalize(ierr)

   call ut%check(res=t%mpi_time, expected=1.0_rk, tol=1.0e-3_rk, msg='test10')

#endif

end program test10

