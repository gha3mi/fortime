[![GitHub](https://img.shields.io/badge/GitHub-ForTime-blue.svg?style=social&logo=github)](https://github.com/gha3mi/fortime)
[![Version](https://img.shields.io/github/release/gha3mi/fortime.svg)](https://github.com/gha3mi/fortime/releases/latest)
[![Documentation](https://img.shields.io/badge/ford-Documentation%20-blueviolet.svg)](https://gha3mi.github.io/fortime/)
[![License](https://img.shields.io/github/license/gha3mi/fortime?color=green)](https://github.com/gha3mi/fortime/blob/main/LICENSE)
[![Build](https://github.com/gha3mi/fortime/actions/workflows/CI-CD.yml/badge.svg)](https://github.com/gha3mi/fortime/actions/workflows/CI-CD.yml)

**ForTime**: A Fortran timing library for measuring wall-clock, date_and_time, CPU, OpenMP and MPI elapsed time.

## fpm dependency

If you want to use `ForTime` as a dependency in your own fpm project,
you can easily include it by adding the following line to your `fpm.toml` file:

```toml
[dependencies]
fortime = {git="https://github.com/gha3mi/fortime.git"}
```

## Usage

`ForTime` exposes the `timer` type, the real kind `rk`, and the integer kind
`ik`. Timing results are stored as `real(rk)` components on the timer object.

### Simple Usage

#### system_clock wall time

```fortran
use fortime, only: timer

type(timer) :: t

call t%timer_start()
! Code to time.
call t%timer_stop()

call t%timer_write('elapsed_time.txt')
```

#### date_and_time wall time

```fortran
use fortime, only: timer

type(timer) :: t

call t%dtimer_start()
! Code to time.
call t%dtimer_stop()

call t%dtimer_write('elapsed_dtime.txt')
```

#### CPU time

```fortran
use fortime, only: timer

type(timer) :: t

call t%ctimer_start()
! Code to time.
call t%ctimer_stop()

call t%ctimer_write('cpu_time.txt')
```

#### OpenMP wall time

```fortran
use fortime, only: timer

type(timer) :: t

call t%otimer_start()
! Code to time.
call t%otimer_stop()

call t%otimer_write('omp_time.txt')
```

Compile with OpenMP enabled and define `USE_OMP`.

#### MPI wall time

```fortran
use fortime, only: timer

type(timer) :: t

call t%mtimer_start()
! Code to time.
call t%mtimer_stop()

call t%mtimer_write('mpi_time.txt')
```

Compile with MPI enabled, define `USE_MPI`, and call the MPI timer while MPI is
initialized.

### Optional Variables and Stop Arguments

All stop routines accept the same optional keyword arguments:

```fortran
call t%timer_stop(nloops,message,print,color,rfmt)
call t%dtimer_stop(nloops,message,print,color,rfmt)
call t%ctimer_stop(nloops,message,print,color,rfmt)
call t%otimer_stop(nloops,message,print,color,rfmt)
call t%mtimer_stop(nloops,message,print,color,rfmt)
```

- `nloops`: positive default-integer loop count used to report an average time.
- `message`: label printed before the timing value.
- `print`: set to `.false.` to suppress output; the default is `.true.`.
- `color`: FACE foreground color for printed output.
- `rfmt`: Fortran real edit descriptor; the default is `F16.9`.

### Loop Averages

```fortran
use fortime, only: timer

type(timer) :: t
integer :: i
integer, parameter :: nloops = 10

call t%timer_start()
do i = 1, nloops
   ! Repeated work.
end do
call t%timer_stop(nloops=nloops, message='Average elapsed time:')
```

### Pause and Resume

```fortran
call t%timer_start()
! Timed work.
call t%timer_pause()
! Work not included in elapsed_time.
call t%timer_resume()
! More timed work.
call t%timer_stop()
```

`timer_pause` and `timer_resume` apply only to the `system_clock` timer.

### Timer Reference

| Timer backend | Start | Stop | Result component | Write routine | Requirement |
| --- | --- | --- | --- | --- | --- |
| `system_clock` | `timer_start` | `timer_stop` | `elapsed_time` | `timer_write` | Always available |
| `date_and_time` | `dtimer_start` | `dtimer_stop` | `elapsed_dtime` | `dtimer_write` | Always available |
| `cpu_time` | `ctimer_start` | `ctimer_stop` | `cpu_time` | `ctimer_write` | Always available |
| `omp_get_wtime` | `otimer_start` | `otimer_stop` | `omp_time` | `otimer_write` | Compile with `USE_OMP` |
| `MPI_Wtime` | `mtimer_start` | `mtimer_stop` | `mpi_time` | `mtimer_write` | Compile with `USE_MPI` |


To measure elapsed time within a pure procedure, use
[ForDebug](https://github.com/gha3mi/fordebug).

## Running Examples and Tests

### Running Examples

To run a specific example from the `example` directory using your preferred Fortran compiler, use the following command:

```shell
fpm run --example <example_name> --compiler <compiler>
```
Replace `<example_name>` with the name of the example file (excluding the `.f90` extension) and `<compiler>` with the name of your Fortran compiler (e.g., `ifx`, `ifort`, `gfortran`, `nvfortran`).

### Running Tests

To execute tests, use the following command with your chosen compiler:

```shell
fpm test --compiler <compiler>
```
Replace `<compiler>` with the name of your Fortran compiler.

## CI Status

<!-- STATUS:setup-fortran-conda:START -->

| OS | Compiler | Version | fpm | cmake |
| --- | --- | ---: | :---: | :---: |
| ubuntu 24.04 | `flang-new` | 22.1.4 | 0.13.0 ✅ | 4.3.2 ✅ |
| ubuntu 24.04 | `gfortran` | 15.2.0 | 0.13.0 ✅ | 4.3.2 ✅ |
| ubuntu 24.04 | `ifx` | 2026.0.0 | 0.13.0 ✅ | 4.3.2 ✅ |
| ubuntu 24.04 | `lfortran` | 0.63.0 | 0.12.0 ✅ | 4.3.2 ✅ |
| ubuntu 24.04 | `nvfortran` | 26.3 | 0.13.0 ✅ | 4.3.2 ✅ |
| macos 15 | `gfortran` | 15.2.0 | 0.13.0 ✅ | 4.3.2 ✅ |
| macos 15 | `lfortran` | 0.63.0 | 0.12.0 ✅ | 4.3.2 ✅ |
| windows 2025 | `flang-new` | 22.1.4 | 0.13.0 ✅ | 4.3.2 ✅ |
| windows 2025 | `gfortran` | 15.2.0 | 0.13.0 ✅ | 4.3.2 ✅ |
| windows 2025 | `ifx` | 2026.0.0 | 0.12.0 ✅ | 4.3.2 ✅ |
| windows 2025 | `lfortran` | 0.54.0 | 0.12.0 ❌ | 4.3.2 ❌ |

<!-- STATUS:setup-fortran-conda:END -->

This table is automatically generated by the CI workflow using [setup-fortran-conda](https://github.com/gha3mi/setup-fortran-conda).

## Documentation

The most up-to-date API documentation for the main branch is available
[here](https://gha3mi.github.io/fortime/).
To generate the API documentation for `ForTime` using
[ford](https://github.com/Fortran-FOSS-Programmers/ford) run the following
command:

```shell
ford README.md
```

## Contributing

Contributions to `ForTime` are welcome! If you find any issues or would like to suggest improvements, please open an issue.
