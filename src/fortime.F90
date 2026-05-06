!> author: Seyed Ali Ghasemi
!> summary: Timing utilities for wall-clock, CPU, OpenMP, MPI, and civil-clock measurements.
!>
!> `fortime` provides the `timer` derived type plus the public real kind `rk`
!> and integer kind `ik`.
!> A single `timer` object can measure several kinds of elapsed time:
!>
!> - `timer_start` / `timer_stop` use the intrinsic `system_clock`.
!> - `ctimer_start` / `ctimer_stop` use the intrinsic `cpu_time`.
!> - `dtimer_start` / `dtimer_stop` use the intrinsic `date_and_time`.
!> - `otimer_start` / `otimer_stop` use `omp_get_wtime` when `USE_OMP` is defined.
!> - `mtimer_start` / `mtimer_stop` use `MPI_Wtime` when `USE_MPI` is defined.
!>
!> The usual workflow is to call a start routine, execute the code being timed,
!> call the matching stop routine, and then read the matching public result
!> component. Stop routines can also print the elapsed time, average it over a
!> positive loop count, and customize the output label, color, and real format.
!>
!> Basic usage:
!>
!> ```fortran
!> use fortime, only: timer
!> type(timer) :: t
!>
!> call t%timer_start()
!> call work()
!> call t%timer_stop(print=.false.)
!> print *, t%elapsed_time
!> ```
!>
!> Loop-averaged usage:
!>
!> ```fortran
!> call t%timer_start()
!> do i = 1, nloops
!>    call work()
!> end do
!> call t%timer_stop(nloops=nloops, message='Average time:', print=.true.)
!> ```
!>
!> @note The `system_clock`, OpenMP, and MPI timers are the preferred wall-clock
!> timers. The `date_and_time` timer is a civil-clock fallback and is not
!> guaranteed to be monotonic.
module fortime

   use, intrinsic :: iso_fortran_env, only: real64, int64, output_unit, error_unit

   implicit none

   private
   public timer, rk, ik

   integer, parameter :: rk = real64
      !! Real kind used by the public timing results and internal real-valued
      !! calculations. It is currently mapped to `real64`.
   integer, parameter :: ik = int64
      !! Integer kind used by the internal tick counters and civil-date
      !! calculations. It is currently mapped to `int64`.

   type timer
      !! author: Seyed Ali Ghasemi
      !! summary: Timing object with independent state for each supported backend.
      !!
      !! A `timer` instance stores private start times and state flags for the
      !! enabled timing backends. The most recent successful measurement from
      !! each backend is exposed through a public result component:
      !! `elapsed_time`, `cpu_time`, `elapsed_dtime`, and, when enabled,
      !! `omp_time` and `mpi_time`.
      !!
      !! Start and stop calls must be matched by backend. For example,
      !! `timer_start` must be followed by `timer_stop`, and `ctimer_start` must
      !! be followed by `ctimer_stop`. Calling a stop routine before its matching
      !! start routine reports an error and leaves the stored result unchanged.

      integer(ik), private :: clock_rate = 0_ik
         !! Cached `system_clock` count rate in ticks per second.
      integer(ik), private :: clock_max = 0_ik
         !! Cached maximum `system_clock` count used to handle one counter wrap.
      integer(ik), private :: clock_start = 0_ik
         !! `system_clock` count captured at the start of the wall-clock interval.

      integer(ik), private :: pause_start = 0_ik
         !! `system_clock` count captured when the wall-clock timer is paused.
      integer(ik), private :: paused_ticks = 0_ik
         !! Total paused duration, in `system_clock` ticks, excluded from the result.

      logical, private :: is_started = .false.
         !! True after `timer_start` and before a successful `timer_stop`.
      logical, private :: is_paused = .false.
         !! True after `timer_pause` and before a matching `timer_resume`.

      real(rk), private :: cpu_start = 0.0_rk
         !! CPU time, in seconds, captured by `ctimer_start`.
      logical, private :: is_cpu_started = .false.
         !! True after `ctimer_start` and before a successful `ctimer_stop`.

#if defined(USE_OMP)
      real(rk), private :: omp_start = 0.0_rk
         !! OpenMP wall-clock time, in seconds, captured by `otimer_start`.
      logical, private :: is_omp_started = .false.
         !! True after `otimer_start` and before a successful `otimer_stop`.
#endif

#if defined(USE_MPI)
      real(rk), private :: mpi_start = 0.0_rk
         !! MPI wall-clock time, in seconds, captured by `mtimer_start`.
      logical, private :: is_mpi_started = .false.
         !! True after `mtimer_start` and before a successful `mtimer_stop`.
#endif

      real(rk), private :: dtime_start_utc = 0.0_rk
         !! UTC epoch seconds computed from `date_and_time` at `dtimer_start`.
      logical, private :: is_dtime_started = .false.
         !! True after `dtimer_start` and before a successful `dtimer_stop`.

      real(rk), public :: elapsed_time = 0.0_rk
         !! Most recent successful `system_clock` elapsed time in seconds.
      real(rk), public :: cpu_time = 0.0_rk
         !! Most recent successful CPU-time measurement in seconds.
#if defined(USE_OMP)
      real(rk), public :: omp_time = 0.0_rk
         !! Most recent successful OpenMP wall-clock measurement in seconds.
#endif
#if defined(USE_MPI)
      real(rk), public :: mpi_time = 0.0_rk
         !! Most recent successful MPI wall-clock measurement in seconds.
#endif
      real(rk), public :: elapsed_dtime = 0.0_rk
         !! Most recent successful `date_and_time` elapsed time in seconds.

   contains
      procedure, public :: timer_start
         !! Start a `system_clock` wall-clock measurement.
      procedure, public :: timer_stop
         !! Stop a `system_clock` wall-clock measurement and update `elapsed_time`.
      procedure, public :: timer_write
         !! Append `elapsed_time` to a text file.
      procedure, public :: timer_pause
         !! Pause a running `system_clock` wall-clock measurement.
      procedure, public :: timer_resume
         !! Resume a paused `system_clock` wall-clock measurement.

      procedure, public :: ctimer_start
         !! Start a CPU-time measurement.
      procedure, public :: ctimer_stop
         !! Stop a CPU-time measurement and update `cpu_time`.
      procedure, public :: ctimer_write
         !! Append `cpu_time` to a text file.

#if defined(USE_OMP)
      procedure, public :: otimer_start
         !! Start an OpenMP wall-clock measurement.
      procedure, public :: otimer_stop
         !! Stop an OpenMP wall-clock measurement and update `omp_time`.
      procedure, public :: otimer_write
         !! Append `omp_time` to a text file.
#endif

#if defined(USE_MPI)
      procedure, public :: mtimer_start
         !! Start an MPI wall-clock measurement.
      procedure, public :: mtimer_stop
         !! Stop an MPI wall-clock measurement and update `mpi_time`.
      procedure, public :: mtimer_write
         !! Append `mpi_time` to a text file.
#endif

      procedure, public :: dtimer_start
         !! Start a `date_and_time` civil-clock measurement.
      procedure, public :: dtimer_stop
         !! Stop a `date_and_time` civil-clock measurement and update `elapsed_dtime`.
      procedure, public :: dtimer_write
         !! Append `elapsed_dtime` to a text file.
   end type timer

contains

   !> author: Seyed Ali Ghasemi
   !> summary: Compute the elapsed tick count between two `system_clock` values.
   !>
   !> The routine handles a single `system_clock` wrap when `t_max` is positive.
   !> If `t_max` is unavailable or non-positive, the routine falls back to direct
   !> subtraction because wrap-safe reconstruction is not possible. The function
   !> result, `dt`, is the tick distance from `t_start` to `t_end`.
   pure integer(ik) function ticks_diff(t_end, t_start, t_max) result(dt)
      integer(ik), intent(in) :: t_end
         !! End tick captured from `system_clock`.
      integer(ik), intent(in) :: t_start
         !! Start tick captured from `system_clock`.
      integer(ik), intent(in) :: t_max
         !! Maximum count returned by `system_clock`; non-positive means unknown.

      if (t_max > 0_ik) then
         if (t_end >= t_start) then
            dt = t_end - t_start
         else
            dt = (t_max - t_start + 1_ik) + t_end
         end if
      else
         dt = t_end - t_start
      end if
   end function ticks_diff


   !> author: Seyed Ali Ghasemi
   !> summary: Validate, average, and optionally print a measured duration.
   !>
   !> This internal helper centralizes the common stop-routine behavior. It
   !> optionally divides the raw duration by `nloops`, selects either the caller's
   !> `message` or the backend-specific `default_label`, respects `print=.false.`,
   !> and returns whether the caller may update its public result component.
   !>
   !> A present `nloops` value must be positive. If `nloops <= 0` or printing
   !> fails, `ok` is returned as `.false.` and the caller leaves the previous
   !> stored result unchanged.
   subroutine finalize_timing(value_raw, nloops, value_out, default_label, message, print, color, rfmt, ok)
      real(rk), intent(in) :: value_raw
         !! Raw measured duration in seconds.
      integer, intent(in), optional :: nloops
         !! Optional positive loop count used to compute an average time per loop.
      real(rk), intent(out) :: value_out
         !! Validated duration in seconds, averaged by `nloops` when present.
      character(*), intent(in) :: default_label
         !! Backend-specific output label used when `message` is absent.
      character(*), intent(in), optional :: message
         !! Optional output label printed before the timing value.
      logical, intent(in), optional :: print
         !! Optional output switch; defaults to `.true.`.
      character(*), intent(in), optional :: color
         !! Optional FACE foreground color for the printed label and unit suffix.
      character(*), intent(in), optional :: rfmt
         !! Optional Fortran real edit descriptor used by `print_time`.
      logical, intent(out) :: ok
         !! True when finalization succeeds and the caller may store `value_out`.

      logical :: do_print
         !! Effective print flag after applying the default value.

      ok = .false.
      value_out = value_raw
      do_print = .true.
      if (present(print)) do_print = print

      if (present(nloops)) then
         if (nloops <= 0) then
            if (do_print) write(error_unit, '(A)') 'Error: nloops must be > 0'
            return
         end if
         value_out = value_out / real(nloops, rk)
      end if

      if (.not. do_print) then
         ok = .true.
         return
      end if

      if (present(message)) then
         call print_time(value_out, message, color, rfmt, ok)
      else
         call print_time(value_out, default_label, color, rfmt, ok)
      end if
   end subroutine finalize_timing


   !> author: Seyed Ali Ghasemi
   !> summary: Start the `system_clock` wall-clock timer.
   !>
   !> `timer_start` resets the pause state, caches `system_clock` metadata when
   !> needed, validates that the clock rate can be converted to seconds, and then
   !> captures the start tick. The matching stop routine is `timer_stop`.
   subroutine timer_start(this)
      class(timer), intent(inout) :: this
         !! Timer instance whose wall-clock state is initialized.

      this%is_started = .true.
      this%is_paused = .false.
      this%paused_ticks = 0_ik

      if (this%clock_rate <= 0_ik .or. this%clock_max <= 0_ik) then
         call system_clock(count_rate=this%clock_rate, count_max=this%clock_max)
      end if

      if (this%clock_rate <= 0_ik) then
         write(error_unit, '(A)') 'Error: system_clock count_rate <= 0; timer unavailable on this platform.'
         this%is_started = .false.
         return
      end if

      call system_clock(count=this%clock_start)
   end subroutine timer_start


   !> author: Seyed Ali Ghasemi
   !> summary: Stop the `system_clock` wall-clock timer and store elapsed seconds.
   !>
   !> `timer_stop` captures the stop tick before validation and reporting work,
   !> subtracts ticks accumulated by `timer_pause` / `timer_resume`, converts the
   !> running interval to seconds, and writes the finalized value to
   !> `elapsed_time`.
   !>
   !> The stored value is updated only when the timer was running, was not paused,
   !> `nloops` is valid, and optional printing succeeds.
   subroutine timer_stop(this, nloops, message, print, color, rfmt)
      class(timer), intent(inout) :: this
         !! Timer instance previously started with `timer_start`.
      integer, intent(in), optional :: nloops
         !! Optional positive loop count used to compute average elapsed time.
      character(*), intent(in), optional :: message
         !! Optional output label; defaults to `Elapsed time:`.
      logical, intent(in), optional :: print
         !! Optional output switch; defaults to `.true.`.
      character(*), intent(in), optional :: color
         !! Optional FACE foreground color used for printed output.
      character(*), intent(in), optional :: rfmt
         !! Optional Fortran real edit descriptor used for printed output.

      integer(ik) :: clock_end
         !! Stop tick captured from `system_clock`.
      integer(ik) :: ticks
         !! Elapsed running ticks after subtracting paused ticks.
      real(rk) :: raw_seconds
         !! Elapsed running time in seconds before optional loop averaging.
      real(rk) :: out_seconds
         !! Final elapsed time after validation and optional loop averaging.
      logical :: ok
         !! Finalization status returned by `finalize_timing`.

      call system_clock(count=clock_end)

      if (.not. this%is_started) then
         write(error_unit, '(A)') 'Error: timer_stop called before timer_start!'
         return
      end if

      if (this%is_paused) then
         write(error_unit, '(A)') 'Error: timer_stop called while timer is paused!'
         return
      end if

      if (this%clock_rate <= 0_ik) then
         write(error_unit, '(A)') 'Error: system_clock count_rate <= 0; cannot compute seconds.'
         this%is_started = .false.
         return
      end if

      ticks = ticks_diff(clock_end, this%clock_start, this%clock_max) - this%paused_ticks
      if (ticks < 0_ik) ticks = 0_ik

      raw_seconds = real(ticks, rk) / real(this%clock_rate, rk)

      this%is_started = .false.
      this%is_paused = .false.
      this%paused_ticks = 0_ik

      call finalize_timing(raw_seconds, nloops, out_seconds, 'Elapsed time:', message, print, color, rfmt, ok)
      if (.not. ok) return
      this%elapsed_time = out_seconds
   end subroutine timer_stop


   !> author: Seyed Ali Ghasemi
   !> summary: Append the last `system_clock` result to a text file.
   !>
   !> The routine writes the current `elapsed_time` value. Existing files are
   !> opened in append mode; missing files are created.
   subroutine timer_write(this, file_name)
      class(timer), intent(in) :: this
         !! Timer instance whose `elapsed_time` value is written.
      character(*), intent(in) :: file_name
         !! Path to the output text file.
      call write_to_file(this%elapsed_time, file_name)
   end subroutine timer_write


   !> author: Seyed Ali Ghasemi
   !> summary: Pause a running `system_clock` wall-clock timer.
   !>
   !> `timer_pause` records the current tick when the wall-clock timer is running
   !> and not already paused. Time spent paused is excluded from `elapsed_time`
   !> after a matching `timer_resume`.
   subroutine timer_pause(this)
      class(timer), intent(inout) :: this
         !! Running wall-clock timer instance to pause.

      if (.not. this%is_started) then
         write(error_unit, '(A)') 'Warning: timer_pause called before timer_start.'
         return
      end if

      if (this%is_paused) then
         write(error_unit, '(A)') 'Warning: timer is already paused.'
         return
      end if

      call system_clock(count=this%pause_start)
      this%is_paused = .true.
   end subroutine timer_pause


   !> author: Seyed Ali Ghasemi
   !> summary: Resume a paused `system_clock` wall-clock timer.
   !>
   !> `timer_resume` measures the paused interval and adds it to `paused_ticks`.
   !> A later `timer_stop` subtracts those ticks from the wall-clock interval.
   subroutine timer_resume(this)
      class(timer), intent(inout) :: this
         !! Paused wall-clock timer instance to resume.

      integer(ik) :: clock_now
         !! Tick captured from `system_clock` at resume time.
      integer(ik) :: pause_dt
         !! Tick duration between `timer_pause` and this resume call.

      if (.not. this%is_started) then
         write(error_unit, '(A)') 'Warning: timer_resume called before timer_start.'
         return
      end if

      if (.not. this%is_paused) then
         write(error_unit, '(A)') 'Warning: timer is not paused.'
         return
      end if

      call system_clock(count=clock_now)
      pause_dt = ticks_diff(clock_now, this%pause_start, this%clock_max)
      if (pause_dt > 0_ik) this%paused_ticks = this%paused_ticks + pause_dt

      this%is_paused = .false.
   end subroutine timer_resume


   !> author: Seyed Ali Ghasemi
   !> summary: Start the CPU-time timer.
   !>
   !> `ctimer_start` captures the process CPU time reported by the intrinsic
   !> `cpu_time`. The matching stop routine is `ctimer_stop`.
   subroutine ctimer_start(this)
      class(timer), intent(inout) :: this
         !! Timer instance whose CPU-time state is initialized.
      call cpu_time(this%cpu_start)
      this%is_cpu_started = .true.
   end subroutine ctimer_start


   !> author: Seyed Ali Ghasemi
   !> summary: Stop the CPU-time timer and store elapsed CPU seconds.
   !>
   !> `ctimer_stop` captures CPU time immediately, validates that `ctimer_start`
   !> was called, optionally averages and prints the duration, and writes the
   !> finalized value to `cpu_time`.
   subroutine ctimer_stop(this, nloops, message, print, color, rfmt)
      class(timer), intent(inout) :: this
         !! Timer instance previously started with `ctimer_start`.
      integer, intent(in), optional :: nloops
         !! Optional positive loop count used to compute average CPU time.
      character(*), intent(in), optional :: message
         !! Optional output label; defaults to `CPU time:`.
      logical, intent(in), optional :: print
         !! Optional output switch; defaults to `.true.`.
      character(*), intent(in), optional :: color
         !! Optional FACE foreground color used for printed output.
      character(*), intent(in), optional :: rfmt
         !! Optional Fortran real edit descriptor used for printed output.

      real(rk) :: cpu_end
         !! CPU time captured at stop.
      real(rk) :: raw_seconds
         !! Raw CPU duration in seconds.
      real(rk) :: out_seconds
         !! Final CPU duration after validation and optional loop averaging.
      logical :: ok
         !! Finalization status returned by `finalize_timing`.

      call cpu_time(cpu_end)

      if (.not. this%is_cpu_started) then
         write(error_unit, '(A)') 'Error: ctimer_stop called before ctimer_start!'
         return
      end if

      this%is_cpu_started = .false.
      raw_seconds = cpu_end - this%cpu_start

      call finalize_timing(raw_seconds, nloops, out_seconds, 'CPU time:', message, print, color, rfmt, ok)
      if (.not. ok) return
      this%cpu_time = out_seconds
   end subroutine ctimer_stop


   !> author: Seyed Ali Ghasemi
   !> summary: Append the last CPU-time result to a text file.
   !>
   !> The routine writes the current `cpu_time` value. Existing files are opened
   !> in append mode; missing files are created.
   subroutine ctimer_write(this, file_name)
      class(timer), intent(in) :: this
         !! Timer instance whose `cpu_time` value is written.
      character(*), intent(in) :: file_name
         !! Path to the output text file.
      call write_to_file(this%cpu_time, file_name)
   end subroutine ctimer_write


#if defined(USE_OMP)
   !> author: Seyed Ali Ghasemi
   !> summary: Start the OpenMP wall-clock timer.
   !>
   !> `otimer_start` is available only when the source is compiled with
   !> `USE_OMP`. It captures `omp_get_wtime` and marks the OpenMP timer as
   !> active. The matching stop routine is `otimer_stop`.
   subroutine otimer_start(this)
      use omp_lib, only: omp_get_wtime
      class(timer), intent(inout) :: this
         !! Timer instance whose OpenMP timing state is initialized.
      this%omp_start = real(omp_get_wtime(), rk)
      this%is_omp_started = .true.
   end subroutine otimer_start


   !> author: Seyed Ali Ghasemi
   !> summary: Stop the OpenMP wall-clock timer and store elapsed seconds.
   !>
   !> `otimer_stop` is available only when the source is compiled with `USE_OMP`.
   !> It captures `omp_get_wtime`, validates that `otimer_start` was called,
   !> optionally averages and prints the duration, and writes the finalized value
   !> to `omp_time`.
   subroutine otimer_stop(this, nloops, message, print, color, rfmt)
      use omp_lib, only: omp_get_wtime
      class(timer), intent(inout) :: this
         !! Timer instance previously started with `otimer_start`.
      integer, intent(in), optional :: nloops
         !! Optional positive loop count used to compute average OpenMP time.
      character(*), intent(in), optional :: message
         !! Optional output label; defaults to `OMP time:`.
      logical, intent(in), optional :: print
         !! Optional output switch; defaults to `.true.`.
      character(*), intent(in), optional :: color
         !! Optional FACE foreground color used for printed output.
      character(*), intent(in), optional :: rfmt
         !! Optional Fortran real edit descriptor used for printed output.

      real(rk) :: omp_end
         !! OpenMP wall time captured at stop.
      real(rk) :: raw_seconds
         !! Raw OpenMP duration in seconds.
      real(rk) :: out_seconds
         !! Final OpenMP duration after validation and optional loop averaging.
      logical :: ok
         !! Finalization status returned by `finalize_timing`.

      omp_end = real(omp_get_wtime(), rk)

      if (.not. this%is_omp_started) then
         write(error_unit, '(A)') 'Error: otimer_stop called before otimer_start!'
         return
      end if

      this%is_omp_started = .false.
      raw_seconds = omp_end - this%omp_start

      call finalize_timing(raw_seconds, nloops, out_seconds, 'OMP time:', message, print, color, rfmt, ok)
      if (.not. ok) return
      this%omp_time = out_seconds
   end subroutine otimer_stop


   !> author: Seyed Ali Ghasemi
   !> summary: Append the last OpenMP wall-clock result to a text file.
   !>
   !> This routine is available only when the source is compiled with `USE_OMP`.
   !> It writes the current `omp_time` value. Existing files are opened in append
   !> mode; missing files are created.
   subroutine otimer_write(this, file_name)
      class(timer), intent(in) :: this
         !! Timer instance whose `omp_time` value is written.
      character(*), intent(in) :: file_name
         !! Path to the output text file.
      call write_to_file(this%omp_time, file_name)
   end subroutine otimer_write
#endif


#if defined(USE_MPI)
   !> author: Seyed Ali Ghasemi
   !> summary: Start the MPI wall-clock timer.
   !>
   !> `mtimer_start` is available only when the source is compiled with
   !> `USE_MPI`. It captures `MPI_Wtime` and marks the MPI timer as active. The
   !> caller is responsible for calling it while MPI is initialized.
   subroutine mtimer_start(this)
      use mpi, only: MPI_Wtime
      class(timer), intent(inout) :: this
         !! Timer instance whose MPI timing state is initialized.
      this%mpi_start = real(MPI_Wtime(), rk)
      this%is_mpi_started = .true.
   end subroutine mtimer_start


   !> author: Seyed Ali Ghasemi
   !> summary: Stop the MPI wall-clock timer and store elapsed seconds.
   !>
   !> `mtimer_stop` is available only when the source is compiled with `USE_MPI`.
   !> It captures `MPI_Wtime`, validates that `mtimer_start` was called,
   !> optionally averages and prints the duration, and writes the finalized value
   !> to `mpi_time`.
   subroutine mtimer_stop(this, nloops, message, print, color, rfmt)
      use mpi, only: MPI_Wtime
      class(timer), intent(inout) :: this
         !! Timer instance previously started with `mtimer_start`.
      integer, intent(in), optional :: nloops
         !! Optional positive loop count used to compute average MPI time.
      character(*), intent(in), optional :: message
         !! Optional output label; defaults to `MPI time:`.
      logical, intent(in), optional :: print
         !! Optional output switch; defaults to `.true.`.
      character(*), intent(in), optional :: color
         !! Optional FACE foreground color used for printed output.
      character(*), intent(in), optional :: rfmt
         !! Optional Fortran real edit descriptor used for printed output.

      real(rk) :: mpi_end
         !! MPI wall time captured at stop.
      real(rk) :: raw_seconds
         !! Raw MPI duration in seconds.
      real(rk) :: out_seconds
         !! Final MPI duration after validation and optional loop averaging.
      logical :: ok
         !! Finalization status returned by `finalize_timing`.

      mpi_end = real(MPI_Wtime(), rk)

      if (.not. this%is_mpi_started) then
         write(error_unit, '(A)') 'Error: mtimer_stop called before mtimer_start!'
         return
      end if

      this%is_mpi_started = .false.
      raw_seconds = mpi_end - this%mpi_start

      call finalize_timing(raw_seconds, nloops, out_seconds, 'MPI time:', message, print, color, rfmt, ok)
      if (.not. ok) return
      this%mpi_time = out_seconds
   end subroutine mtimer_stop


   !> author: Seyed Ali Ghasemi
   !> summary: Append the last MPI wall-clock result to a text file.
   !>
   !> This routine is available only when the source is compiled with `USE_MPI`.
   !> It writes the current `mpi_time` value. Existing files are opened in append
   !> mode; missing files are created.
   subroutine mtimer_write(this, file_name)
      class(timer), intent(in) :: this
         !! Timer instance whose `mpi_time` value is written.
      character(*), intent(in) :: file_name
         !! Path to the output text file.
      call write_to_file(this%mpi_time, file_name)
   end subroutine mtimer_write
#endif


   !> author: Seyed Ali Ghasemi
   !> summary: Convert a civil calendar date to days since the Unix epoch.
   !>
   !> This internal helper uses proleptic Gregorian calendar arithmetic and maps
   !> 1970-01-01 to day zero. It is used by `epoch_seconds_utc` to convert the
   !> date fields returned by `date_and_time` into an epoch-relative day count.
   !> The function result is the signed day count relative to 1970-01-01.
   pure integer(ik) function days_from_civil(y, m, d) result(days)
      integer(ik), intent(in) :: y
         !! Civil year in the proleptic Gregorian calendar.
      integer(ik), intent(in) :: m
         !! Civil month in the range 1 to 12.
      integer(ik), intent(in) :: d
         !! Civil day of month.
      integer(ik) :: y2
         !! Year adjusted so March is treated as the first month.
      integer(ik) :: m2
         !! Month adjusted so March is treated as month 3 of the adjusted year.
      integer(ik) :: era
         !! Complete 400-year era containing the adjusted year.
      integer(ik) :: yoe
         !! Year of era.
      integer(ik) :: doy
         !! Day of adjusted year.
      integer(ik) :: doe
         !! Day of era.

      y2 = y
      m2 = m
      if (m2 <= 2_ik) then
         y2 = y2 - 1_ik
         m2 = m2 + 12_ik
      end if

      era = y2 / 400_ik
      yoe = y2 - era * 400_ik
      doy = (153_ik * (m2 - 3_ik) + 2_ik) / 5_ik + d - 1_ik
      doe = yoe * 365_ik + yoe / 4_ik - yoe / 100_ik + doy

      days = era * 146097_ik + doe - 719468_ik
   end function days_from_civil


   !> author: Seyed Ali Ghasemi
   !> summary: Convert `date_and_time` values to UTC epoch seconds.
   !>
   !> `date_and_time` reports local civil time plus a time-zone offset in
   !> minutes. This internal helper converts the civil date to epoch days, adds
   !> the local time of day, and subtracts the time-zone offset so start and stop
   !> values can be differenced across day, month, or year boundaries. The
   !> function result is UTC epoch seconds represented with kind `rk`.
   pure real(rk) function epoch_seconds_utc(values) result(t)
      integer, intent(in) :: values(8)
         !! Eight-element result from `date_and_time(values=...)`.
      integer(ik) :: y
         !! Year extracted from `values(1)`.
      integer(ik) :: m
         !! Month extracted from `values(2)`.
      integer(ik) :: d
         !! Day extracted from `values(3)`.
      integer(ik) :: days
         !! Signed day count relative to 1970-01-01.
      integer(ik) :: secs
         !! Whole seconds from the local civil date and time fields.
      integer :: tzmin
         !! Time-zone offset in minutes east of UTC.

      y = int(values(1), ik)
      m = int(values(2), ik)
      d = int(values(3), ik)

      tzmin = values(4)
      if (abs(tzmin) > 24*60) tzmin = 0

      days = days_from_civil(y, m, d)
      secs = days * 86400_ik + &
             int(values(5), ik) * 3600_ik + &
             int(values(6), ik) * 60_ik + &
             int(values(7), ik)

      t = real(secs, rk) + real(values(8), rk) / 1000.0_rk - real(tzmin, rk) * 60.0_rk
   end function epoch_seconds_utc


   !> author: Seyed Ali Ghasemi
   !> summary: Start the `date_and_time` wall-clock timer.
   !>
   !> `dtimer_start` captures the current `date_and_time` values, converts them
   !> to UTC epoch seconds, and marks the date/time timer as active. The matching
   !> stop routine is `dtimer_stop`.
   !>
   !> @note This timer follows civil-clock time and is not guaranteed to be
   !> monotonic.
   subroutine dtimer_start(this)
      class(timer), intent(inout) :: this
         !! Timer instance whose date/time timing state is initialized.
      integer :: v(8)
         !! Raw `date_and_time` values captured at start.

      call date_and_time(values=v)
      this%dtime_start_utc = epoch_seconds_utc(v)
      this%is_dtime_started = .true.
   end subroutine dtimer_start


   !> author: Seyed Ali Ghasemi
   !> summary: Stop the `date_and_time` timer and store elapsed seconds.
   !>
   !> `dtimer_stop` captures `date_and_time` immediately, converts the stop value
   !> to UTC epoch seconds, validates that `dtimer_start` was called, optionally
   !> averages and prints the duration, and writes the finalized value to
   !> `elapsed_dtime`.
   subroutine dtimer_stop(this, nloops, message, print, color, rfmt)
      class(timer), intent(inout) :: this
         !! Timer instance previously started with `dtimer_start`.
      integer, intent(in), optional :: nloops
         !! Optional positive loop count used to compute average date/time duration.
      character(*), intent(in), optional :: message
         !! Optional output label; defaults to `Elapsed time:`.
      logical, intent(in), optional :: print
         !! Optional output switch; defaults to `.true.`.
      character(*), intent(in), optional :: color
         !! Optional FACE foreground color used for printed output.
      character(*), intent(in), optional :: rfmt
         !! Optional Fortran real edit descriptor used for printed output.

      integer :: v(8)
         !! Raw `date_and_time` values captured at stop.
      real(rk) :: t_end
         !! Stop time converted to UTC epoch seconds.
      real(rk) :: raw_seconds
         !! Raw elapsed date/time duration in seconds.
      real(rk) :: out_seconds
         !! Final date/time duration after validation and optional loop averaging.
      logical :: ok
         !! Finalization status returned by `finalize_timing`.

      call date_and_time(values=v)
      t_end = epoch_seconds_utc(v)

      if (.not. this%is_dtime_started) then
         write(error_unit, '(A)') 'Error: dtimer_stop called before dtimer_start!'
         return
      end if

      this%is_dtime_started = .false.
      raw_seconds = t_end - this%dtime_start_utc

      call finalize_timing(raw_seconds, nloops, out_seconds, 'Elapsed time:', message, print, color, rfmt, ok)
      if (.not. ok) return
      this%elapsed_dtime = out_seconds
   end subroutine dtimer_stop


   !> author: Seyed Ali Ghasemi
   !> summary: Append the last `date_and_time` result to a text file.
   !>
   !> The routine writes the current `elapsed_dtime` value. Existing files are
   !> opened in append mode; missing files are created.
   subroutine dtimer_write(this, file_name)
      class(timer), intent(in) :: this
         !! Timer instance whose `elapsed_dtime` value is written.
      character(*), intent(in) :: file_name
         !! Path to the output text file.
      call write_to_file(this%elapsed_dtime, file_name)
   end subroutine dtimer_write


   !> author: Seyed Ali Ghasemi
   !> summary: Print a formatted timing value.
   !>
   !> This internal helper builds a runtime format from `rfmt`, colorizes the
   !> label and unit suffix with FACE, and writes to `output_unit`. Formatting
   !> errors are reported through `error_unit`; `ok` tells callers whether the
   !> write completed successfully.
   subroutine print_time(time, message, color, rfmt, ok)
      use face, only: colorize
      real(rk), intent(in) :: time
         !! Timing value in seconds.
      character(*), intent(in) :: message
         !! Label printed before `time`.
      character(*), intent(in), optional :: color
         !! Optional FACE foreground color; defaults to `blue`.
      character(*), intent(in), optional :: rfmt
         !! Optional Fortran real edit descriptor; defaults to `F16.9`.
      logical, intent(out) :: ok
         !! True when the formatted write completed successfully.

      character(len=:), allocatable :: color_
         !! Effective FACE color name.
      character(len=:), allocatable :: fmt
         !! Complete runtime format built from `rfmt_`.
      character(len=:), allocatable :: rfmt_
         !! Effective real edit descriptor after trimming and defaulting.
      integer :: ios
         !! I/O status returned by the formatted write.
      character(len=256) :: iomsg
         !! Diagnostic message returned by the formatted write.

      ok = .false.

      if (present(rfmt)) then
         rfmt_ = adjustl(trim(rfmt))
      else
         rfmt_ = 'F16.9'
      end if

      if (len_trim(rfmt_) == 0) then
         write(error_unit, '(A)') 'Error: rfmt must not be empty'
         return
      end if

      if (present(color)) then
         color_ = trim(color)
      else
         color_ = 'blue'
      end if

      fmt = '(A, ' // trim(rfmt_) // ', A)'
      write(output_unit, fmt, iostat=ios, iomsg=iomsg) &
         colorize(trim(message), color_fg=color_), time, colorize(' [s]', color_fg=color_)
      if (ios /= 0) then
         write(error_unit, '(A)') 'Error writing formatted time: ' // trim(iomsg)
         return
      end if

      ok = .true.
   end subroutine print_time


   !> author: Seyed Ali Ghasemi
   !> summary: Append a timing value to a text file.
   !>
   !> This internal helper opens an existing file in append mode or creates a new
   !> file, writes one timing value using `g0` formatting, and reports file I/O
   !> errors through `error_unit`.
   subroutine write_to_file(time, file_name)
      real(rk), intent(in) :: time
         !! Timing value in seconds to write.
      character(*), intent(in) :: file_name
         !! Path to the output text file.

      character(len=:), allocatable :: fname
         !! Trimmed output file path.
      logical :: file_exists
         !! True when `fname` already exists.
      integer :: nunit
         !! Scratch unit number assigned by `open(newunit=...)`.
      integer :: ios
         !! I/O status code returned by file operations.
      character(len=256) :: iomsg
         !! Diagnostic message returned by file I/O operations.

      fname = trim(file_name)
      inquire(file=fname, exist=file_exists)

      if (file_exists) then
         open(newunit=nunit, file=fname, status='old', action='write', position='append', iostat=ios, iomsg=iomsg)
      else
         open(newunit=nunit, file=fname, status='new', action='write', iostat=ios, iomsg=iomsg)
      end if

      if (ios /= 0) then
         write(error_unit, '(A)') 'Error opening file: ' // fname // ' : ' // trim(iomsg)
         return
      end if

      write(nunit, '(g0)', iostat=ios, iomsg=iomsg) time
      if (ios /= 0) then
         write(error_unit, '(A)') 'Error writing file: ' // fname // ' : ' // trim(iomsg)
      end if

      close(nunit)
   end subroutine write_to_file

end module fortime
