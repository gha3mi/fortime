[![GitHub](https://img.shields.io/badge/GitHub-ForTime-blue.svg?style=social&logo=github)](https://github.com/gha3mi/fortime)
[![Version](https://img.shields.io/github/release/gha3mi/fortime.svg)](https://github.com/gha3mi/fortime/releases/latest)
[![Documentation](https://img.shields.io/badge/ford-Documentation%20-blueviolet.svg)](https://gha3mi.github.io/fortime/)
[![License](https://img.shields.io/github/license/gha3mi/fortime?color=green)](https://github.com/gha3mi/fortime/blob/main/LICENSE)
[![Build](https://github.com/gha3mi/fortime/actions/workflows/CI_test.yml/badge.svg)](https://github.com/gha3mi/fortime/actions/workflows/CI_test.yml)

<img alt="ForTime" src="https://github.com/gha3mi/fortime/raw/main/media/logo.png" width="750">

**ForTime**: A Fortran library for measuring elapsed time, DATE_AND_TIME time, CPU time, OMP time and MPI time.

## fpm dependency

If you want to use `ForTime` as a dependency in your own fpm project,
you can easily include it by adding the following line to your `fpm.toml` file:

```toml
[dependencies]
fortime = {git="https://github.com/gha3mi/fortime.git"}
```

## Usage

### Measuring elapsed time

To measure the elapsed wall-clock time, use the following:

```fortran
use fortime
type(timer) :: t

call t%timer_start()
! Your code or section to be timed
call t%timer_stop(nloops, message, print) ! nloops, message and print are optional

call t%timer_write(file_name) ! Optionally, write the result to a file
```

### Measuring elapsed time (date_and_time)

To measure the elapsed wall-clock time, use the following:

```fortran
use fortime
type(timer) :: t

call t%dtimer_start()
! Your code or section to be timed
call t%dtimer_stop(nloops, message, print) ! nloops, message and print are optional

call t%dtimer_write(file_name) ! Optionally, write the result to a file
```

### Measuring CPU time

To measure the CPU time consumed by your code, use these functions:

```fortran
use fortime
type(timer) :: t

call t%ctimer_start()
! Your code or section to be timed
call t%ctimer_stop(nloops, message, print) ! nloops, message and print are optional

call t%ctimer_write(file_name) ! Optionally, write the result to a file
```

### Measuring OpenMP (OMP) time

If your code includes OpenMP parallelization, you can measure the time taken by the parallel regions using:

```fortran
use fortime
type(timer) :: t

call t%otimer_start()
! Your code or section to be timed
call t%otimer_stop(nloops, message, print) ! nloops, message and print are optional

call t%otimer_write(file_name) ! Optionally, write the result to a file
```

**Note:** Ensure you compile with the `-DUSE_OMP` option when using the OpenMP timer.

### Measuring MPI time

When using MPI (Message Passing Interface), you can measure the time taken by your MPI processes using:

```fortran
use fortime
type(timer) :: t

call t%mtimer_start()
! Your code or section to be timed
call t%mtimer_stop(nloops, message, print) ! nloops, message and print are optional

call t%mtimer_write(file_name) ! Optionally, write the result to a file
```

**Note:** Don't forget to compile with the `-DUSE_MPI` option when using the MPI timer.

## How to run examples

**Clone the repository:**

You can clone the `ForTime` repository from GitHub using the following command:

```shell
git clone https://github.com/gha3mi/fortime.git
cd fortime
```

**For Intel Fortran Compiler (ifort):**

  ```shell
  fpm run --example --all --compiler ifort
  ```

**For Intel Fortran Compiler (ifx):**

  ```shell
  fpm run --example --all --compiler ifx
  ```

**For NVIDIA Compiler (nvfortran):**

  ```shell
  fpm run --example --all --compiler nvfortran
  ```

**For GNU Fortran Compiler (gfortran):**

  ```shell
  fpm run --example --all --compiler gfortran
  ```

## How to run tests


**For Intel Fortran Compiler (ifort):**

  ```shell
  fpm test --compiler ifort
  ```

**For Intel Fortran Compiler (ifx):**

  ```shell
  fpm test --compiler ifx
  ```

**For NVIDIA Compiler (nvfortran):**

  ```shell
  fpm test --compiler nvfortran
  ```

**For GNU Fortran Compiler (gfortran):**

  ```shell
  fpm test --compiler gfortran
  ```

## API documentation

The most up-to-date API documentation for the master branch is available
[here](https://gha3mi.github.io/fortime/).
To generate the API documentation for `ForTime` using
[ford](https://github.com/Fortran-FOSS-Programmers/ford) run the following
command:

```shell
ford ford.yml
```

## Contributing

Contributions to `ForTime` are welcome! If you find any issues or would like to suggest improvements, please open an issue.
