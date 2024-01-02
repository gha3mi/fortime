 !> This module provides a timer object for measuring elapsed time.
 !> It includes procedures for starting and stopping the timer, as well
 !> as calculating and printing the elapsed time in seconds.
module fortime

   use kinds

   implicit none

   private

   public :: timer, timer_start, timer_stop

   !===============================================================================
   type :: timer
      integer, private :: clock_rate       ! Processor clock rate
      integer, private :: clock_start      ! Start time in processor ticks
      integer, private :: clock_end        ! End time in processor ticks
      integer, private :: clock_elapsed    ! Elapsed time in processor ticks
      real(rk)         :: elapsed_time     ! Elapsed time in seconds

      real(rk), private :: cpu_start       ! Start CPU time
      real(rk), private :: cpu_end         ! End CPU time
      real(rk), private :: cpu_elapsed     ! Elapsed CPU time
      real(rk)          :: cpu_time        ! Elapsed time in seconds

#if defined(USE_OMP)
      real(rk), private :: omp_start       ! Start OMP time
      real(rk), private :: omp_end         ! End OMP time
      real(rk), private :: omp_elapsed     ! Elapsed OMP time
      real(rk)          :: omp_time        ! Elapsed time in seconds
#endif

#if defined(USE_MPI)
      real(rk), private :: mpi_start       ! Start MPI time
      real(rk), private :: mpi_end         ! End MPI time
      real(rk), private :: mpi_elapsed     ! Elapsed MPI time
      real(rk)          :: mpi_time        ! Elapsed time in seconds
#endif

      integer, dimension(8), private :: values_start     ! Start date and time values
      integer, dimension(8), private :: values_end       ! End date and time values
      integer, dimension(8), private :: values_elapsed   ! Elapsed date and time values
      real(rk)                       :: elapsed_dtime    ! Elapsed time in seconds
   contains
      procedure :: timer_start     ! Procedure for starting the timer
      procedure :: timer_stop      ! Procedure for stopping the timer
      procedure :: timer_write     ! Procedure for writing elapsed time to a file

      procedure :: ctimer_start    ! Procedure for starting the CPU timer
      procedure :: ctimer_stop     ! Procedure for stopping the CPU timer
      procedure :: ctimer_write    ! Procedure for writing elapsed CPU time to a file

#if defined(USE_OMP)
      procedure :: otimer_start    ! Procedure for starting the OMP timer
      procedure :: otimer_stop     ! Procedure for stopping the OMP timer
      procedure :: otimer_write    ! Procedure for writing elapsed OMP time to a file
#endif

#if defined(USE_MPI)
      procedure :: mtimer_start    ! Procedure for starting the MPI timer
      procedure :: mtimer_stop     ! Procedure for stopping the MPI timer
      procedure :: mtimer_write    ! Procedure for writing elapsed MPI time to a file
#endif

      procedure :: dtimer_start     ! Procedure for starting the date_and_time timer
      procedure :: dtimer_stop      ! Procedure for stopping the date_and_time timer
      procedure :: dtimer_write     ! Procedure for writing elapsed date_and_time time to a file
   end type
   !===============================================================================

contains

   !===============================================================================
   !> author: Seyed Ali Ghasemi
   !> Starts the timer by recording the current processor clock value.
   !> This value is used to calculate the elapsed time later.
   impure subroutine timer_start(this)
      class(timer), intent(inout) :: this

      ! Get the processor clock rate
      call system_clock(count_rate=this%clock_rate)

      ! Start the timer
      call system_clock(count=this%clock_start)

   end subroutine timer_start
   !===============================================================================


   !===============================================================================
   !> author: Seyed Ali Ghasemi
   !> Stops the timer and calculates the elapsed time.
   !> Optionally, it can print a message along with the elapsed time.
   impure subroutine timer_stop(this, nloops, message, print)
      class(timer), intent(inout)        :: this
      integer,      intent(in), optional :: nloops
      character(*), intent(in), optional :: message
      character(:), allocatable          :: msg
      logical,      intent(in), optional :: print

      ! Stop the timer
      call system_clock(count=this%clock_end)

      ! Calculate the elapsed processor ticks
      this%clock_elapsed = this%clock_end - this%clock_start

      ! Convert processor ticks to seconds
      if (.not.present(nloops)) &
      this%elapsed_time = real(this%clock_elapsed, kind=rk) / real(this%clock_rate, kind=rk)
      if (     present(nloops)) &
      this%elapsed_time = real(this%clock_elapsed, kind=rk) / real(this%clock_rate, kind=rk) / real(nloops, kind=rk)

      ! Print the elapsed time
      if (.not. present(message)) then
         msg = "Elapsed time:"
      else
         msg = message
      end if

      if (present(print)) then
         if (print) call print_time(this%elapsed_time, msg)
      else
         call print_time(this%elapsed_time, msg)
      end if

      ! Deallocate the message
      if (allocated(msg)) deallocate(msg)

   end subroutine timer_stop
   !===============================================================================


   !===============================================================================
   !> author: Seyed Ali Ghasemi
   !> Writes the elapsed time to a file.
   impure subroutine timer_write(this, file_name)
      class(timer), intent(in) :: this
      character(*), intent(in) :: file_name
      logical                  :: file_exists
      integer                  :: nunit

      ! Check if the file exists
      inquire(file=file_name, exist=file_exists)

      ! Open the file in appropriate mode
      if (file_exists) then
         open(newunit=nunit, file=file_name, status='old', action='write', position='append')
      else
         open(newunit=nunit, file=file_name, status='new', action='write')
      end if

      ! Write the elapsed time to the file
      write(nunit, '(g0)') this%elapsed_time

      ! Close the file
      close(nunit)

   end subroutine timer_write
   !===============================================================================


   !===============================================================================
   !> author: Seyed Ali Ghasemi
   !> Starts the timer by recording the current CPU time value.
   !> This value is used to calculate the CPU time later.
   impure subroutine ctimer_start(this)
      class(timer), intent(inout) :: this

      ! Start the timer
      call cpu_time(this%cpu_start)

   end subroutine ctimer_start
   !===============================================================================


   !===============================================================================
   !> author: Seyed Ali Ghasemi
   !> Stops the timer and calculates the CPU time.
   !> Optionally, it can print a message along with the CPU time.
   impure subroutine ctimer_stop(this, nloops, message, print)
      class(timer), intent(inout)        :: this
      integer,      intent(in), optional :: nloops
      character(*), intent(in), optional :: message
      character(:), allocatable          :: msg
      logical,      intent(in), optional :: print

      ! Stop the timer
      call cpu_time(this%cpu_end)

      ! Calculate the elapsed CPU time
      this%cpu_elapsed = this%cpu_end - this%cpu_start

      ! Convert CPU time to seconds
      if (.not.present(nloops)) this%cpu_time = this%cpu_elapsed
      if (     present(nloops)) this%cpu_time = this%cpu_elapsed / real(nloops, kind=rk)

      ! Print the elapsed time
      if (.not. present(message)) then
         msg = "CPU time:"
      else
         msg = message
      end if

      if (present(print)) then
         if (print) call print_time(this%cpu_time, msg)
      else
         call print_time(this%cpu_time, msg)
      end if

      ! Deallocate the message
      if (allocated(msg)) deallocate(msg)

   end subroutine ctimer_stop
   !===============================================================================


   !===============================================================================
   !> author: Seyed Ali Ghasemi
   !> Writes the CPU time to a file.
   impure subroutine ctimer_write(this, file_name)
      class(timer), intent(in) :: this
      character(*), intent(in) :: file_name
      logical                  :: file_exists
      integer                  :: nunit

      ! Check if the file exists
      inquire(file=file_name, exist=file_exists)

      ! Open the file in appropriate mode
      if (file_exists) then
         open(newunit=nunit, file=file_name, status='old', action='write', position='append')
      else
         open(newunit=nunit, file=file_name, status='new', action='write')
      end if

      ! Write the CPU time to the file
      write(nunit, '(g0)') this%cpu_time

      ! Close the file
      close(nunit)

   end subroutine ctimer_write
   !===============================================================================


   !===============================================================================
   !> author: Seyed Ali Ghasemi
   !> Starts the timer by recording the current OMP time value.
   !> This value is used to calculate the OMP time later.
#if defined(USE_OMP)
   impure subroutine otimer_start(this)
      use omp_lib
      class(timer), intent(inout) :: this

      ! Start the timer
      this%omp_start = omp_get_wtime()

   end subroutine otimer_start
   !===============================================================================
#endif


#if defined(USE_OMP)
   !===============================================================================
   !> author: Seyed Ali Ghasemi
   !> Stops the timer and calculates the OMP time.
   !> Optionally, it can print a message along with the OMP time.
   impure subroutine otimer_stop(this, nloops, message, print)
      use omp_lib
      class(timer), intent(inout)        :: this
      integer,      intent(in), optional :: nloops
      character(*), intent(in), optional :: message
      character(:), allocatable          :: msg
      logical,      intent(in), optional :: print

      ! Stop the timer
      this%omp_end = omp_get_wtime()

      ! Calculate the elapsed OMP time
      this%omp_elapsed = this%omp_end - this%omp_start

      ! Convert OMP time to seconds
      if (.not.present(nloops)) this%omp_time = this%omp_elapsed
      if (     present(nloops)) this%omp_time = this%omp_elapsed / real(nloops, kind=rk)

      ! Print the elapsed time
      if (.not. present(message)) then
         msg = "OMP time:"
      else
         msg = message
      end if

      if (present(print)) then
         if (print) call print_time(this%omp_time, msg)
      else
         call print_time(this%omp_time, msg)
      end if

      ! Deallocate the message
      if (allocated(msg)) deallocate(msg)

   end subroutine otimer_stop
   !===============================================================================
#endif


#if defined(USE_OMP)
   !===============================================================================
   !> author: Seyed Ali Ghasemi
   !> Writes the OMP time to a file.
   impure subroutine otimer_write(this, file_name)
      use omp_lib
      class(timer), intent(in) :: this
      character(*), intent(in) :: file_name
      logical                  :: file_exists
      integer                  :: nunit

      ! Check if the file exists
      inquire(file=file_name, exist=file_exists)

      ! Open the file in appropriate mode
      if (file_exists) then
         open(newunit=nunit, file=file_name, status='old', action='write', position='append')
      else
         open(newunit=nunit, file=file_name, status='new', action='write')
      end if

      ! Write the OMP time to the file
      write(nunit, '(g0)') this%omp_time

      ! Close the file
      close(nunit)

   end subroutine otimer_write
   !===============================================================================
#endif


#if defined(USE_MPI)
   !===============================================================================
   !> author: Seyed Ali Ghasemi
   !> Starts the timer by recording the current MPI time value.
   !> This value is used to calculate the MPI time later.
   impure subroutine mtimer_start(this)
      ! include 'mpif.h'
      class(timer), intent(inout) :: this

      interface
         function mpi_wtime()
            import rk
            real(rk) :: mpi_wtime
         end function mpi_wtime
      end interface

      ! Start the timer
      this%mpi_start = mpi_wtime()

   end subroutine mtimer_start
   !===============================================================================
#endif


#if defined(USE_MPI)
   !===============================================================================
   !> author: Seyed Ali Ghasemi
   !> Stops the timer and calculates the MPI time.
   !> Optionally, it can print a message along with the MPI time.
   impure subroutine mtimer_stop(this, nloops, message, print)
      ! include 'mpif.h'
      class(timer), intent(inout)        :: this
      integer,      intent(in), optional :: nloops
      character(*), intent(in), optional :: message
      character(:), allocatable          :: msg
      logical,      intent(in), optional :: print

      interface
         function mpi_wtime()
            import rk
            real(rk) :: mpi_wtime
         end function mpi_wtime
      end interface

      ! Stop the timer
      this%mpi_end = mpi_wtime()

      ! Calculate the elapsed MPI time
      this%mpi_elapsed = this%mpi_end - this%mpi_start

      ! Convert MPI time to seconds
      if (.not.present(nloops)) this%mpi_time = this%mpi_elapsed
      if (     present(nloops)) this%mpi_time = this%mpi_elapsed / real(nloops, kind=rk)

      ! Print the elapsed time
      if (.not. present(message)) then
         msg = "MPI time:"
      else
         msg = message
      end if

      if (present(print)) then
         if (print) call print_time(this%mpi_time, msg)
      else
         call print_time(this%mpi_time, msg)
      end if

      ! Deallocate the message
      if (allocated(msg)) deallocate(msg)

   end subroutine mtimer_stop
   !===============================================================================
#endif


#if defined(USE_MPI)
   !===============================================================================
   !> author: Seyed Ali Ghasemi
   !> Writes the MPI time to a file.
   impure subroutine mtimer_write(this, file_name)
      class(timer), intent(in) :: this
      character(*), intent(in) :: file_name
      logical                  :: file_exists
      integer                  :: nunit

      ! Check if the file exists
      inquire(file=file_name, exist=file_exists)

      ! Open the file in appropriate mode
      if (file_exists) then
         open(newunit=nunit, file=file_name, status='old', action='write', position='append')
      else
         open(newunit=nunit, file=file_name, status='new', action='write')
      end if

      ! Write the MPI time to the file
      write(nunit, '(g0)') this%mpi_time

      ! Close the file
      close(nunit)

   end subroutine mtimer_write
   !===============================================================================
#endif


   !===============================================================================
   !> author: Seyed Ali Ghasemi
   !> Starts the timer by recording the current processor clock value.
   !> This value is used to calculate the elapsed time later.
   impure subroutine dtimer_start(this)
      class(timer), intent(inout) :: this

      ! Start the timer
      call date_and_time(values=this%values_start)

   end subroutine dtimer_start
   !===============================================================================


   !===============================================================================
   !> author: Seyed Ali Ghasemi
   !> Stops the timer and calculates the elapsed time.
   !> Optionally, it can print a message along with the elapsed time.
   impure subroutine dtimer_stop(this, nloops, message, print)
      class(timer), intent(inout)        :: this
      integer,      intent(in), optional :: nloops
      character(*), intent(in), optional :: message
      character(:), allocatable          :: msg
      logical,      intent(in), optional :: print
      real(rk)                           :: values_elapsed_sec

      ! Stop the timer
      call date_and_time(values=this%values_end)

      ! Calculate the elapsed processor ticks
      this%values_elapsed = this%values_end - this%values_start

      ! Convert processor ticks to seconds
      if (.not.present(nloops)) &
         this%elapsed_dtime = to_seconds(this%values_elapsed)
      if (     present(nloops)) &
         this%elapsed_dtime = to_seconds(this%values_elapsed) / real(nloops, kind=rk)

      ! Print the elapsed time
      if (.not. present(message)) then
         msg = "Elapsed time:"
      else
         msg = message
      end if

      if (present(print)) then
         if (print) call print_time(this%elapsed_dtime, msg)
      else
         call print_time(this%elapsed_dtime, msg)
      end if

      ! Deallocate the message
      if (allocated(msg)) deallocate(msg)

   end subroutine dtimer_stop
   !===============================================================================


   !===============================================================================
   !> author: Seyed Ali Ghasemi
   !> Writes the elapsed time to a file.
   impure subroutine dtimer_write(this, file_name)
      class(timer), intent(in) :: this
      character(*), intent(in) :: file_name
      logical                  :: file_exists
      integer                  :: nunit

      ! Check if the file exists
      inquire(file=file_name, exist=file_exists)

      ! Open the file in appropriate mode
      if (file_exists) then
         open(newunit=nunit, file=file_name, status='old', action='write', position='append')
      else
         open(newunit=nunit, file=file_name, status='new', action='write')
      end if

      ! Write the elapsed time to the file
      write(nunit, '(g0)') this%elapsed_dtime

      ! Close the file
      close(nunit)

   end subroutine dtimer_write
   !===============================================================================


   !===============================================================================
   !> author: Seyed Ali Ghasemi
   pure function to_seconds(values) result(seconds)
      integer, dimension(8), intent(in) :: values
      real(rk)                          :: seconds

      seconds = real(values(3), rk) * 24.0_rk * 60.0_rk * 60.0_rk + &
                real(values(5), rk) * 60.0_rk * 60.0_rk + &
                real(values(6), rk) * 60.0_rk + &
                real(values(7), rk)

   end function to_seconds
   !===============================================================================


   !===============================================================================
   !> author: Seyed Ali Ghasemi
   impure subroutine print_time(time, message)
      real(rk),     intent(in) :: time
      character(*), intent(in) :: message

      print '(A, F16.9, " [s]")', trim(message), time
   end subroutine print_time
   !===============================================================================

end module fortime
