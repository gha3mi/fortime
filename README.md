![ForTime](media/logo.png)
============

**ForTime**: This module provides a timer object for measuring elapsed time. It includes procedures for starting and stopping the timer, as well as calculating and printing the elapsed time in seconds.

## How to Use ForTime

### Adding ForTime as an fpm Dependency

If you want to use ForTime as a dependency in your own fpm project,
you can easily include it by adding the following line to your `fpm.toml` file:

```toml
[dependencies]
fortime = {git="https://github.com/gha3mi/fortime.git"}
```

### Installation of ForTime Library

To use ForTime, follow the steps below:

- **Reuirements:**

  Fortran Compiler

- **Clone the repository:**

   You can clone the ForTime repository from GitHub using the following command:

   ```shell
   git clone https://github.com/gha3mi/fortime.git
   ```

   ```shell
   cd fortime
   ```

- **Build using the Fortran Package Manager (fpm):**

   ForTime can be built using [fpm](https://github.com/fortran-lang/fpm).
   Make sure you have fpm installed, and then execute the following command:

  **GNU Fortran Compiler (gfortran)**

   ```shell
   fpm install --prefix . --compiler gfortran
   ```

  **Intel Fortran Compiler (ifort)**

   ```shell
   fpm install --prefix . --compiler ifort
   ```

  **Intel Fortran Compiler (ifx)**

    ```shell
   fpm install --prefix . --compiler ifx
   ```

## Type: `timer`
A type representing a timer object with the following components:
- `clock_rate`: Processor clock rate
- `clock_start`: Start time in processor ticks
- `clock_end`: End time in processor ticks
- `clock_elapsed`: Elapsed time in processor ticks
- `elapsed_time`: Elapsed time in seconds


## Procedures:
- `timer_start(this)`: Starts the timer by recording the current processor clock value. This value is used to calculate the elapsed time later.
- `timer_stop(this, nloops, message)`: Stops the timer and calculates the elapsed time. Optionally, it can print a message along with the elapsed time.
- `timer_write(this, file_name)`: Writes the elapsed time to a file.

## Usage:
1. Include the `fortime` module in your program.
2. Declare a variable of type `timer` to use as a timer object.
3. Call the `timer_start` procedure to start the timer.
4. Perform the desired operations.
5. Call the `timer_stop` procedure to stop the timer and calculate the elapsed time.
6. Optionally, call the `timer_write` procedure to write the elapsed time to a file.

## Running Examples Using fpm

To run the examples using `fpm`, you can use response files for specific compilers:

  **Intel Fortran Compiler (ifort)**

  ```bash
  fpm @example-ift
  ```

  **Intel Fortran Compiler (ifx)**

  ```bash
  fpm @example-ifx
  ```

  **NVIDIA Compiler (nvfortran)**

  ```bash
  fpm @example-nv
  ```

  **GNU Fortran Compiler (gfortran)**

  ```bash
  fpm @example-gf
  ```

## Example
```fortran
program example
   implicit none
   
   use :: fortime

   type(timer) :: t

   call timer_start(t)   ! Start the timer

   ! Perform operations here

   call timer_stop(t)    ! Stop the timer and print the elapsed time

   ! Optionally, write the elapsed time to a file
   call timer_write(t,"output.txt")

end program example
```

## API Documentation

To generate the API documentation for the `ForTime` module using
[ford](https://github.com/Fortran-FOSS-Programmers/ford) run the following
command:

```shell
ford ford.yml
```

## Contributing
Contributions to `ForTime` are welcome! If you find any issues or would like to suggest improvements, please open an issue or submit a pull request.