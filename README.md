# 8 Bit CPU

SystemVerilog implementation of an 8 bit CPU, designed with a custom Instruction Set Architecture.
It is a Harvard Architecture, using 512 bytes of program memory and 16 kilobytes of data memory.
This was designed for and deployed on a DE-10 Lite FPGA.
Additionally, I have written an assembler to compile the custom machine code from a custom assembly language.

## Overview

TODO
This Section will eventually contain images and videos demonstrating the usage of this CPU.

TODO
Replace all instances of ./docs/demos/.gitkeep with the actual intended demo file

## Replicate This Project

### Prerequisites

Deploying this CPU yourself requires the following things

- C compiler (GCC, CLANG, etc.)
- [DE-10 Lite](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=234&No=1021), or an equivalent FPGA
- [Intel Quartus Prime software](https://www.altera.com/products/development-tools/quartus)

### Deploying

#### Clone the Repository

```
git clone https://github.com/nolanflores/8-bit-cpu.git
```
or use the SSH link
```
git clone git@github.com:nolanflores/8-bit-cpu.git
```

#### Create A Program File

1. If you are using a linux system, use the provided [bash script](./assembler/compile) to compile the assembler, otherwise use a C compiler of choice to compile the included [assembler.c](./assembler/assembler.c)
2. Write an assembly program using the custom [assembly language](./docs/manuals/Balls%20Assembly%20Manual.txt)
3. Run the compiled assembler, passing the name of your assembly file as a command line argument.
4. Assuming the assembly succeeds, it will output a .mif file containing the machine code

#### Compile The Project

1. In order to compile, a file named "prog.mif" must exist in the [quartus directory](./quartus/). An [example program](./quartus/prog.mif) already exists here. To run the program that you created in the previous section, your compiled .mif file must replace the provided example.
2. Once the desired program is in the quartus directory, open the [8-Bit-CPU.qpf](./quartus/8-Bit-CPU.qpf) project file in Quartus.
3. If you are not using a DE-10 Lite, you will have to change the pin mapping to whatever makes the most sense for your board. I will include a description of the pins in a [documentation file](./docs/manuals/Pin%20Descriptions.txt).
4. Compile the project with Quartus.
5. Use the Quartus Programmer tool to program your FPGA device.

#### Cycle The Clock

The default behavior of the CPU is to use the 50 MHz clock onboard the [DE-10 Lite](./docs/manuals/DE10-Lite%20User%20Manual.pdf).
In order to manually control the clock, a jumper wire will have to be placed between one the GND and IO0 pins on the Arduino Header on the board, [demonstrated here](./docs/demos/.gitkeep). Once the two pins are connected, the CPU clock will be controlled by the KEY0 button, while the KEY1 button will act as the reset. The 10 leds on the board will turn on and off to display the number of cycles in the current instruction.

## Authors

* **Nolan Flores** - [nolanflores](https://github.com/nolanflores)

## License

This project is open source.

## Software Used

* [Intel Quartus](https://www.altera.com/products/development-tools/quartus)
* [ModelSim](https://www.altera.com/downloads/simulation-tools/modelsim-fpgas-pro-edition-software-version-21-1)