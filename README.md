![ForTime](media/logo.png)
============

**ForTime**: This module provides a timer object for measuring elapsed time. It includes procedures for starting and stopping the timer, as well as calculating and printing the elapsed time in seconds.

-----
## Table of Contents

- [](#)
  - [Table of Contents](#table-of-contents)
  - [Installation](#installation)
    - [fpm](#fpm)
  - [Type: `timer`](#type-timer)
  - [Procedures:](#procedures)
  - [Usage:](#usage)
  - [Tests](#tests)
  - [Example:](#example)
  - [Documentation](#documentation)
  - [Contributing](#contributing)
-----


## Installation

### fpm
ForTime can be cloned and then built using [fpm](https://github.com/fortran-lang/fpm), following the instructions provided in the documentation available on Fortran Package Manager.

```bash
git clone https://github.com/gha3mi/fortime.git
cd fortime
fpm install --prefix .
```

Or you can easily include this package as a dependency in your `fpm.toml` file.

```toml
[dependencies]
fortime = {git="https://github.com/gha3mi/fortime.git"}
```

-----

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
-----

## Usage:
1. Include the `fortime` module in your program.
2. Declare a variable of type `timer` to use as a timer object.
3. Call the `timer_start` procedure to start the timer.
4. Perform the desired operations.
5. Call the `timer_stop` procedure to stop the timer and calculate the elapsed time.
6. Optionally, call the `timer_write` procedure to write the elapsed time to a file.
-----

## Tests

The `tests` directory contains test programs to verify the functionality of the `fortime` module. To run the tests using `fpm`, you can use response files for specific compilers:

- For Intel Fortran Compiler (ifort):
```bash
fpm @ifort
```

- For Intel Fortran Compiler (ifx):
```bash
fpm @ifx
```

- For NVIDIA Compiler (nvfortran):
```bash
fpm @nvidia
```

- For GNU Fortran Compiler (gfortran):
```bash
fpm @gfortran
```
-----

## Example:
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
-----


## Documentation
To generate the documentation for the `fortime` module using [ford](https://github.com/Fortran-FOSS-Programmers/ford) run the following command:
```bash
ford project.yml
```

-----

## Contributing

Contributions to fortime are welcome! If you find any issues or would like to suggest improvements, please open an issue or submit a pull request.