program check

   use fortime, only: timer
   use forunittest, only: unit_test, rk

   implicit none

#if defined(USE_MPI)
   interface
      subroutine mpi_init(ierr)
         implicit none
         integer, intent(out) :: ierr
      end subroutine mpi_init

      subroutine mpi_finalize(ierr)
         implicit none
         integer, intent(out) :: ierr
      end subroutine mpi_finalize
   end interface
#endif

   type(unit_test) :: ut
#if defined(USE_MPI)
   integer :: ierr

   call mpi_init(ierr)
#endif

   call run_test1(ut)
   call run_test2(ut)
   call run_test3(ut)
   call run_test4(ut)
   call run_test5(ut)
   call run_test6(ut)
   call run_test7(ut)
   call run_test8(ut)
   call run_test9(ut)
   call run_test10(ut)
   call run_test11(ut)
   call run_test12(ut)
   call run_test13(ut)
   call run_test14(ut)
   call run_test15(ut)
   call run_test16(ut)
   call run_test17(ut)
   call run_test18(ut)
   call run_test19(ut)
   call run_test20(ut)
   call run_test21(ut)
   call run_test22(ut)
   call run_test23(ut)
   call run_test24(ut)
   call run_test25(ut)
   call run_test26(ut)
   call run_test27(ut)
   call run_test28(ut)
   call run_test29(ut)
   call run_test30(ut)
   call run_test31(ut)
   call run_test32(ut)

#if defined(USE_MPI)
   call mpi_finalize(ierr)
#endif

contains

   subroutine run_test1(ut)
      type(unit_test), intent(inout) :: ut
      type(timer) :: t

      call t%timer_start()
      call sleep(1)
      call t%timer_stop()

      call ut%check(res=t%elapsed_time, expected=1.0_rk, tol=1.0e-1_rk, msg="test1")
   end subroutine run_test1

   subroutine run_test2(ut)
      type(unit_test), intent(inout) :: ut
      type(timer) :: t
      integer :: nl
      integer, parameter :: nloops = 3

      call t%timer_start()
      do nl = 1, nloops
         call sleep(1)
      end do
      call t%timer_stop(nloops = nloops, message = "Elapsed time:")
      call t%timer_write("test/test2_etimes.txt")

      call ut%check(res=t%elapsed_time, expected=1.0_rk, tol=1.0e-1_rk, msg="test2")
   end subroutine run_test2

   subroutine run_test3(ut)
      type(unit_test), intent(inout) :: ut
      type(timer) :: t
      integer :: nl
      integer, parameter :: nloops = 3

      call t%timer_start()
      do nl = 1, nloops
         call sleep(1)
      end do
      call t%timer_stop(message = "Elapsed time:")
      call t%timer_write("test/test3_etimes.txt")

      call ut%check(res=t%elapsed_time, expected=real(nloops,rk)*1.0_rk, tol=1.0e-1_rk, msg="test3")
   end subroutine run_test3

   subroutine run_test4(ut)
      type(unit_test), intent(inout) :: ut
      type(timer) :: t

      call t%ctimer_start()
      call sleep(1)
      call t%ctimer_stop()

      call ut%check(res=t%cpu_time >= 0.0_rk, expected=.true., msg="test4")
   end subroutine run_test4

   subroutine run_test5(ut)
      type(unit_test), intent(inout) :: ut
      type(timer) :: t
      integer :: nl
      integer, parameter :: nloops = 3

      call t%ctimer_start()
      do nl = 1, nloops
         call sleep(1)
      end do
      call t%ctimer_stop(nloops = nloops, message = "CPU time:")
      call t%ctimer_write("test/test5_ctimes.txt")

      call ut%check(res=t%cpu_time >= 0.0_rk, expected=.true., msg="test5")
   end subroutine run_test5

   subroutine run_test6(ut)
      type(unit_test), intent(inout) :: ut
      type(timer) :: t
      integer :: nl
      integer, parameter :: nloops = 3

      call t%ctimer_start()
      do nl = 1, nloops
         call sleep(1)
      end do
      call t%ctimer_stop(message = "CPU time:")
      call t%ctimer_write("test/test6_ctimes.txt")

      call ut%check(res=t%cpu_time >= 0.0_rk, expected=.true., msg="test6")
   end subroutine run_test6

   subroutine run_test7(ut)
      type(unit_test), intent(inout) :: ut
#if defined(USE_OMP)
      type(timer) :: t

      call t%otimer_start()
      call sleep(1)
      call t%otimer_stop()

      call ut%check(res=t%omp_time, expected=1.0_rk, tol=1.0e-1_rk, msg="test7")
#else
      call ut%check(res=.true., expected=.true., msg="test7 skipped USE_OMP")
#endif
   end subroutine run_test7

   subroutine run_test8(ut)
      type(unit_test), intent(inout) :: ut
#if defined(USE_OMP)
      type(timer) :: t
      integer :: nl
      integer, parameter :: nloops = 3

      call t%otimer_start()
      do nl = 1, nloops
         call sleep(1)
      end do
      call t%otimer_stop(nloops = nloops, message = "OMP time:")
      call t%otimer_write("test/test8_otimes.txt")

      call ut%check(res=t%omp_time, expected=1.0_rk, tol=1.0e-1_rk, msg="test8")
#else
      call ut%check(res=.true., expected=.true., msg="test8 skipped USE_OMP")
#endif
   end subroutine run_test8

   subroutine run_test9(ut)
      type(unit_test), intent(inout) :: ut
#if defined(USE_OMP)
      type(timer) :: t
      integer :: nl
      integer, parameter :: nloops = 3

      call t%otimer_start()
      do nl = 1, nloops
         call sleep(1)
      end do
      call t%otimer_stop(message = "OMP time:")
      call t%otimer_write("test/test9_otimes")

      call ut%check(res=t%omp_time, expected=real(nloops,rk)*1.0_rk, tol=1.0e-1_rk, msg="test9")
#else
      call ut%check(res=.true., expected=.true., msg="test9 skipped USE_OMP")
#endif
   end subroutine run_test9

   subroutine run_test10(ut)
      type(unit_test), intent(inout) :: ut
#if defined(USE_MPI)
      type(timer) :: t

      call t%mtimer_start()
      call sleep(1)
      call t%mtimer_stop()

      call ut%check(res=t%mpi_time, expected=1.0_rk, tol=1.0e-1_rk, msg="test10")
#else
      call ut%check(res=.true., expected=.true., msg="test10 skipped USE_MPI")
#endif
   end subroutine run_test10

   subroutine run_test11(ut)
      type(unit_test), intent(inout) :: ut
#if defined(USE_MPI)
      type(timer) :: t
      integer :: nl
      integer, parameter :: nloops = 3

      call t%mtimer_start()
      do nl = 1, nloops
         call sleep(1)
      end do
      call t%mtimer_stop(nloops = nloops, message = "MPI time:")
      call t%mtimer_write("test/test11_mtimes.txt")

      call ut%check(res=t%mpi_time, expected=1.0_rk, tol=1.0e-1_rk, msg="test11")
#else
      call ut%check(res=.true., expected=.true., msg="test11 skipped USE_MPI")
#endif
   end subroutine run_test11

   subroutine run_test12(ut)
      type(unit_test), intent(inout) :: ut
#if defined(USE_MPI)
      type(timer) :: t
      integer :: nl
      integer, parameter :: nloops = 3

      call t%mtimer_start()
      do nl = 1, nloops
         call sleep(1)
      end do
      call t%mtimer_stop(message = "MPI time:")
      call t%mtimer_write("test/test12_mtimes")

      call ut%check(res=t%mpi_time, expected=real(nloops,rk)*1.0_rk, tol=1.0e-1_rk, msg="test12")
#else
      call ut%check(res=.true., expected=.true., msg="test12 skipped USE_MPI")
#endif
   end subroutine run_test12

   subroutine run_test13(ut)
      type(unit_test), intent(inout) :: ut
      type(timer) :: t

      call t%timer_start()
      call sleep(1)
      call t%timer_stop(print=.false.)

      call ut%check(res=t%elapsed_time, expected=1.0_rk, tol=1.0e-1_rk, msg="test13")
   end subroutine run_test13

   subroutine run_test14(ut)
      type(unit_test), intent(inout) :: ut
      type(timer) :: t
      integer :: nl
      integer, parameter :: nloops = 3

      call t%timer_start()
      do nl = 1, nloops
         call sleep(1)
      end do
      call t%timer_stop(nloops = nloops, message = "Elapsed time:", print=.false.)
      call t%timer_write("test/test14_etimes.txt")

      call ut%check(res=t%elapsed_time, expected=1.0_rk, tol=1.0e-1_rk, msg="test14")
   end subroutine run_test14

   subroutine run_test15(ut)
      type(unit_test), intent(inout) :: ut
      type(timer) :: t
      integer :: nl
      integer, parameter :: nloops = 3

      call t%timer_start()
      do nl = 1, nloops
         call sleep(1)
      end do
      call t%timer_stop(message = "Elapsed time:", print=.false.)
      call t%timer_write("test/test15_etimes.txt")

      call ut%check(res=t%elapsed_time, expected=real(nloops,rk)*1.0_rk, tol=1.0e-1_rk, msg="test15")
   end subroutine run_test15

   subroutine run_test16(ut)
      type(unit_test), intent(inout) :: ut
      type(timer) :: t

      call t%ctimer_start()
      call sleep(1)
      call t%ctimer_stop(print=.false.)

      call ut%check(res=t%cpu_time >= 0.0_rk, expected=.true., msg="test16")
   end subroutine run_test16

   subroutine run_test17(ut)
      type(unit_test), intent(inout) :: ut
      type(timer) :: t
      integer :: nl
      integer, parameter :: nloops = 3

      call t%ctimer_start()
      do nl = 1, nloops
         call sleep(1)
      end do
      call t%ctimer_stop(nloops = nloops, message = "CPU time:", print=.false.)
      call t%ctimer_write("test/test17_ctimes.txt")

      call ut%check(res=t%cpu_time >= 0.0_rk, expected=.true., msg="test17")
   end subroutine run_test17

   subroutine run_test18(ut)
      type(unit_test), intent(inout) :: ut
      type(timer) :: t
      integer :: nl
      integer, parameter :: nloops = 3

      call t%ctimer_start()
      do nl = 1, nloops
         call sleep(1)
      end do
      call t%ctimer_stop(message = "CPU time:", print=.false.)
      call t%ctimer_write("test/test18_ctimes.txt")

      call ut%check(res=t%cpu_time >= 0.0_rk, expected=.true., msg="test18")
   end subroutine run_test18

   subroutine run_test19(ut)
      type(unit_test), intent(inout) :: ut
#if defined(USE_OMP)
      type(timer) :: t

      call t%otimer_start()
      call sleep(1)
      call t%otimer_stop(print=.false.)

      call ut%check(res=t%omp_time, expected=1.0_rk, tol=1.0e-1_rk, msg="test19")
#else
      call ut%check(res=.true., expected=.true., msg="test19 skipped USE_OMP")
#endif
   end subroutine run_test19

   subroutine run_test20(ut)
      type(unit_test), intent(inout) :: ut
#if defined(USE_OMP)
      type(timer) :: t
      integer :: nl
      integer, parameter :: nloops = 3

      call t%otimer_start()
      do nl = 1, nloops
         call sleep(1)
      end do
      call t%otimer_stop(nloops = nloops, message = "OMP time:", print=.false.)
      call t%otimer_write("test/test20_otimes.txt")

      call ut%check(res=t%omp_time, expected=1.0_rk, tol=1.0e-1_rk, msg="test20")
#else
      call ut%check(res=.true., expected=.true., msg="test20 skipped USE_OMP")
#endif
   end subroutine run_test20

   subroutine run_test21(ut)
      type(unit_test), intent(inout) :: ut
#if defined(USE_OMP)
      type(timer) :: t
      integer :: nl
      integer, parameter :: nloops = 3

      call t%otimer_start()
      do nl = 1, nloops
         call sleep(1)
      end do
      call t%otimer_stop(message = "OMP time:", print=.false.)
      call t%otimer_write("test/test21_otimes")

      call ut%check(res=t%omp_time, expected=real(nloops,rk)*1.0_rk, tol=1.0e-1_rk, msg="test21")
#else
      call ut%check(res=.true., expected=.true., msg="test21 skipped USE_OMP")
#endif
   end subroutine run_test21

   subroutine run_test22(ut)
      type(unit_test), intent(inout) :: ut
#if defined(USE_MPI)
      type(timer) :: t

      call t%mtimer_start()
      call sleep(1)
      call t%mtimer_stop(print=.false.)

      call ut%check(res=t%mpi_time, expected=1.0_rk, tol=1.0e-1_rk, msg="test22")
#else
      call ut%check(res=.true., expected=.true., msg="test22 skipped USE_MPI")
#endif
   end subroutine run_test22

   subroutine run_test23(ut)
      type(unit_test), intent(inout) :: ut
#if defined(USE_MPI)
      type(timer) :: t
      integer :: nl
      integer, parameter :: nloops = 3

      call t%mtimer_start()
      do nl = 1, nloops
         call sleep(1)
      end do
      call t%mtimer_stop(nloops = nloops, message = "MPI time:", print=.false.)
      call t%mtimer_write("test/test23_mtimes.txt")

      call ut%check(res=t%mpi_time, expected=1.0_rk, tol=1.0e-1_rk, msg="test23")
#else
      call ut%check(res=.true., expected=.true., msg="test23 skipped USE_MPI")
#endif
   end subroutine run_test23

   subroutine run_test24(ut)
      type(unit_test), intent(inout) :: ut
#if defined(USE_MPI)
      type(timer) :: t
      integer :: nl
      integer, parameter :: nloops = 3

      call t%mtimer_start()
      do nl = 1, nloops
         call sleep(1)
      end do
      call t%mtimer_stop(message = "MPI time:", print=.false.)
      call t%mtimer_write("test/test24_mtimes")

      call ut%check(res=t%mpi_time, expected=real(nloops,rk)*1.0_rk, tol=1.0e-1_rk, msg="test24")
#else
      call ut%check(res=.true., expected=.true., msg="test24 skipped USE_MPI")
#endif
   end subroutine run_test24

   subroutine run_test25(ut)
      type(unit_test), intent(inout) :: ut
      type(timer) :: t

      call t%dtimer_start()
      call sleep(1)
      call t%dtimer_stop()

      call ut%check(res=t%elapsed_dtime, expected=1.0_rk, tol=1.0e-1_rk, msg="test25")
   end subroutine run_test25

   subroutine run_test26(ut)
      type(unit_test), intent(inout) :: ut
      type(timer) :: t
      integer :: nl
      integer, parameter :: nloops = 3

      call t%dtimer_start()
      do nl = 1, nloops
         call sleep(1)
      end do
      call t%dtimer_stop(nloops = nloops, message = "Elapsed time:")
      call t%dtimer_write("test/test26_etimes.txt")

      call ut%check(res=t%elapsed_dtime, expected=1.0_rk, tol=1.0e-1_rk, msg="test26")
   end subroutine run_test26

   subroutine run_test27(ut)
      type(unit_test), intent(inout) :: ut
      type(timer) :: t
      integer :: nl
      integer, parameter :: nloops = 3

      call t%dtimer_start()
      do nl = 1, nloops
         call sleep(1)
      end do
      call t%dtimer_stop(message = "Elapsed time:")
      call t%dtimer_write("test/test27_etimes.txt")

      call ut%check(res=t%elapsed_dtime, expected=real(nloops,rk)*1.0_rk, tol=1.0e-1_rk, msg="test27")
   end subroutine run_test27

   subroutine run_test28(ut)
      type(unit_test), intent(inout) :: ut
      type(timer) :: t

      call t%dtimer_start()
      call sleep(1)
      call t%dtimer_stop(print=.false.)

      call ut%check(res=t%elapsed_dtime, expected=1.0_rk, tol=1.0e-1_rk, msg="test28")
   end subroutine run_test28

   subroutine run_test29(ut)
      type(unit_test), intent(inout) :: ut
      type(timer) :: t
      integer :: nl
      integer, parameter :: nloops = 3

      call t%dtimer_start()
      do nl = 1, nloops
         call sleep(1)
      end do
      call t%dtimer_stop(nloops = nloops, message = "Elapsed time:", print=.false.)
      call t%dtimer_write("test/test29_etimes.txt")

      call ut%check(res=t%elapsed_dtime, expected=1.0_rk, tol=1.0e-1_rk, msg="test29")
   end subroutine run_test29

   subroutine run_test30(ut)
      type(unit_test), intent(inout) :: ut
      type(timer) :: t
      integer :: nl
      integer, parameter :: nloops = 3

      call t%dtimer_start()
      do nl = 1, nloops
         call sleep(1)
      end do
      call t%dtimer_stop(message = "Elapsed time:", print=.false.)
      call t%dtimer_write("test/test30_etimes.txt")

      call ut%check(res=t%elapsed_dtime, expected=real(nloops,rk)*1.0_rk, tol=1.0e-1_rk, msg="test30")
   end subroutine run_test30

   subroutine run_test31(ut)
      type(unit_test), intent(inout) :: ut
      type(timer) :: t

      call t%timer_start()
      call sleep(1)
      call t%timer_pause()
      call sleep(1)
      call t%timer_resume()
      call sleep(1)
      call t%timer_stop()

      call ut%check(res=t%elapsed_time, expected=2.0_rk, tol=1.0e-1_rk, msg="test31")
   end subroutine run_test31

   subroutine run_test32(ut)
      type(unit_test), intent(inout) :: ut
      type(timer) :: t

      t%elapsed_time = 42.0_rk
      call t%timer_start()
      call t%timer_stop(nloops=0, print=.false.)
      call ut%check(res=t%elapsed_time, expected=42.0_rk, tol=0.0_rk, msg="test32 nloops")
   end subroutine run_test32

end program check
