# ForTime

A Fortran library for measuring elapsed time, CPU time, OMP time and MPI time.

It includes procedures for starting and stopping the timer,
as well as calculating, printing and writing the elapsed times in seconds.

![ForTime](media/logo.png)

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

## Running Examples Using fpm

To run the examples using `fpm`, you can use response files for specific compilers:

- Intel Fortran Compiler (ifort)

  ```bash
  fpm @example-ift
  ```

- Intel Fortran Compiler (ifx)

  ```bash
  fpm @example-ifx
  ```

- NVIDIA Compiler (nvfortran)

  ```bash
  fpm @example-nv
  ```

- GNU Fortran Compiler (gfortran)

  ```bash
  fpm @example-gf
  ```

## API Documentation

To generate the API documentation for the `ForTime` module using
[ford](https://github.com/Fortran-FOSS-Programmers/ford) run the following
command:

```shell
ford ford.yml
```

## Contributing

Contributions to `ForTime` are welcome!
If you find any issues or would like to suggest improvements,
please open an issue or submit a pull request.
